import os
import shutil
import json
import requests
from datetime import datetime, timedelta
from intent_classifier import IntentClassifier
from pydantic import SecretStr

from langchain_openai import OpenAIEmbeddings
from langchain_chroma import Chroma
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain_community.document_loaders import PyPDFLoader
from langchain.prompts import ChatPromptTemplate
from langchain_core.documents import Document
from langchain_core.prompt_values import PromptValue
from dotenv import load_dotenv
from chatbot_instructions import build_output_format_template, PROMPT_TEMPLATE_CHATBOT
from langcodes import Language

load_dotenv()


class ChildMonitoringRAG:
    def __init__(
        self,
        data_dir: str,
        similarity_threshold: float = 0.25,
        top_k: int = 3,
    ):
        self.data_dir = data_dir
        self.persist_directory = os.getenv("VECTOR_DB_PATH", "chroma_db")
        self.embedding_model_name = os.getenv(
            "EMBEDDING_MODEL", "text-embedding-3-small"
        )
        self.similarity_threshold = similarity_threshold
        self.top_k = top_k
        self.backend_api_base_url = os.getenv(
            "BACKEND_API_BASE_URL", "http://localhost:8000/api/analysis"
        )

        api_key = os.getenv("OPENAI_API_KEY")
        self.embeddings = OpenAIEmbeddings(
            model=self.embedding_model_name,
            api_key=SecretStr(api_key) if api_key else None,
        )

        self.vectorstore = None
        self.retriever = None

        self.intent_classifier = IntentClassifier(
            model_name="gpt-4o-mini",
        )

    def _load_documents(self) -> list[Document]:
        """
        Load documents from the data directory (PDF file).
        Returns a list of Document objects, where each document is typically a page.
        """
        documents = []
        for filename in os.listdir(self.data_dir):
            if filename.endswith(".pdf"):
                file_path = os.path.join(self.data_dir, filename)
                loader = PyPDFLoader(file_path)
                loaded_docs = loader.load()
                documents.extend(loaded_docs)
                print(f"Loaded {len(loaded_docs)} documents from {file_path}")
        return documents

    def _setup_vector_store(self, chunk_size: int = 1000):
        """
        Create vector store and set up retriever.
        """
        if os.path.exists(self.persist_directory):
            shutil.rmtree(self.persist_directory)
        print("Loading documents for new vector store...")
        documents = self._load_documents()
        print("Setting up new vector database...")

        text_splitter = RecursiveCharacterTextSplitter(
            chunk_size=chunk_size,
            chunk_overlap=int(chunk_size * 0.1),
            separators=["\n\n", "\n", ".", "!", "?", ",", " "],
            length_function=len,
        )

        splits = text_splitter.split_documents(documents)
        print(f"Split documents into {len(splits)} chunks.")

        self.vectorstore = Chroma.from_documents(
            documents=splits,
            embedding=self.embeddings,
            persist_directory=self.persist_directory,  # Use self.persist_directory
        )
        print(
            f"Vector store created at {self.persist_directory} with {len(splits)} chunks."
        )

    def _make_backend_api_call(self, api_details: dict, token: str) -> dict[str, str]:
        """
        Makes API calls to the backend based on the classified intent's details.
        Handles multiple API types if present in api_details['api_type'].
        Returns a dictionary mapping API type to its JSON response string.
        """

        results = {}
        for api_detail in api_details:
            url = self.backend_api_base_url
            api_type = api_detail.get("api_type")
            url += f"/{api_type}"

            # Params
            params_str = ""

            # Themes
            if api_type == "concept-performance":
                themes = api_detail.get("themes")
                if len(themes) > 0:
                    themes_str = ",".join(themes)
                    params_str += f"themes={themes_str}&"

            # Time Unit
            time_unit = api_detail.get("time_unit")
            if time_unit:
                params_str += f"time_unit={time_unit}&"

            # Num Periods
            num_periods = api_detail.get("num_periods")
            if num_periods:
                params_str += f"num_periods={num_periods}&"

            # Start Date
            start_date = api_detail.get("start_date")
            if start_date:
                params_str += f"start_date={start_date}&"

            # Start Date
            end_date = api_detail.get("end_date")
            if end_date:
                params_str += f"end_date={end_date}&"

            if params_str != "":
                url += f"?{params_str}"
                url = url[:-1]

            print(f"Trying to call URL: {url}")
            header = {
                "Authorization": f"Bearer {token}" if token else "",
            }
            # Call the backend
            response = requests.get(
                url=url,
                headers=header,
            )
            results[api_type] = response.content.decode("utf-8")

        return results

    def _get_children_data_context(
        self, query: str, token: str, lang_code: str
    ) -> dict:
        """
        Fetch children's data context based on the query.
        This method makes an API call to the backend to retrieve the relevant data.
        Returns a dictionary with the children's data context.
        """

        if lang_code != "en":
            print(
                f"Translating query from {Language.get(lang_code).display_name()} to English..."
            )
            response = requests.post(
                "http://localhost:8003/translate",
                json={
                    "q": query,
                    "source": lang_code,
                    "target": "en",
                    "format": "text",
                    "alternatives": 3,
                    "api_key": "",
                },
                headers={"Content-Type": "application/json"},
            )

            translation_result = response.json()
            query = translation_result.get("translatedText", query)

        api_details = self.intent_classifier.classify(query)
        intent = api_details.get("intent")
        if intent != "child_performance_data":
            return {}

        try:
            
            response = self._make_backend_api_call(api_details.get("api_call_details", []), token)
            return response
        except Exception as e:
            print(f"An error occurred while fetching children's data: {e}")
            return {}

    def _get_rag_context(self, query: str, lang_code) -> str:
        """
        Fetches the RAG context based on the query.
        This method retrieves relevant documents from the vector store.
        Returns a string containing the RAG context.
        """
        if not self.retriever:
            print("Retriever not initialized. Ensure initialize_rag() was called.")
            return ""

        try:
            if lang_code != "id":
                print(
                    f"Translating query from {Language.get(lang_code).display_name()} to Indonesian..."
                )
                response = requests.post(
                    "http://localhost:8003/translate",
                    json={
                        "q": query,
                        "source": lang_code,
                        "target": "id",
                        "format": "text",
                        "alternatives": 3,
                        "api_key": "",
                    },
                    headers={"Content-Type": "application/json"},
                )

                translation_result = response.json()
                query = translation_result.get("translatedText", query)

            rag_context_docs = self.retriever.invoke(query)
            rag_context_text = "\n\n".join(
                [doc.page_content for doc in rag_context_docs]
            )
            return rag_context_text.strip()
        except Exception as e:
            print(f"Error retrieving RAG documents: {e}")
            return ""

    def initialize_rag(self, rebuild: bool = False):
        """
        Initialize the complete RAG system.
        Args:
            rebuild (bool): If True, forces a rebuild of the vector store
                            even if it already exists.
        """
        print("Initializing RAG system...")

        if os.path.exists(self.persist_directory) and not rebuild:
            print("Using existing vector store from:", self.persist_directory)
            self.vectorstore = Chroma(
                persist_directory=self.persist_directory,
                embedding_function=self.embeddings,
            )
            if self.vectorstore._collection.count() == 0:
                print("Existing vector store is empty, rebuilding...")
                self._setup_vector_store()
        else:
            print("Creating new vector store...")
            self._setup_vector_store()

        if self.vectorstore is not None:
            self.retriever = self.vectorstore.as_retriever(
                search_type="similarity_score_threshold",
                search_kwargs={
                    "k": self.top_k,
                    "score_threshold": self.similarity_threshold,
                },
            )
        else:
            print("Error: Vector store is not initialized.")
            return

        print(
            f"Retriever initialized with top_k={self.top_k} and similarity threshold={self.similarity_threshold}."
        )
        print("RAG system initialized successfully.")

    def create_prompt(
        self, query: str, child_age: int, lang_code: str, token: str
    ) -> PromptValue:
        """
        Creates a formatted prompt for the LLM, combining children's data context and RAG context.
        """
        # DEBUG lang_code
        print(f"Creating prompt for query: {query} with child age: {child_age} and language code: {lang_code}")
        
        # Get children's data context
        print("Retrieving children's data context...")
        children_data_context = self._get_children_data_context(query, token, lang_code)
        if not children_data_context:
            print("No children's data context found for the query.")
            children_data_context = "No children's data context found for the query."

        # Get RAG context documents
        print("Retrieving RAG context documents...")
        rag_context_text = self._get_rag_context(query, lang_code)
        if not rag_context_text:
            print("No RAG context found for the query.")
            rag_context_text = "No RAG context found for the query."

        output_format = build_output_format_template()

        prompt = ChatPromptTemplate.from_template(PROMPT_TEMPLATE_CHATBOT)
        formatted_prompt = prompt.format_prompt(
            children_data_context=children_data_context,
            rag_context_text=rag_context_text,
            query=query,
            output_format=output_format,
            child_age=child_age,
            language=(
                Language.get(lang_code).display_name() if lang_code else "Indonesian"
            ),
        )

        return formatted_prompt