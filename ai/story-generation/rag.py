import os
import shutil
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain_community.document_loaders import DirectoryLoader
from langchain_chroma import Chroma
from langchain_openai import OpenAIEmbeddings
from langchain.prompts import ChatPromptTemplate
import json
from dotenv import load_dotenv
from story_instructions import StoryInstructions, PROMPT_TEMPLATE
from langcodes import Language
import requests

load_dotenv()

class IndonesianStoryRAG:
    def __init__(
        self,
        data_dir: str,
        similarity_threshold: float = 0.1,
        top_k: int = 5,
    ):
        self.data_dir = data_dir
        self.persist_directory = os.getenv("VECTOR_DB_PATH", "chroma_db")
        self.embeddings = OpenAIEmbeddings(model=os.getenv("EMBEDDING_MODEL", "text-embedding-3-small"))
        self.vectorstore = None
        self.retriever = None
        self.similarity_threshold = similarity_threshold
        self.top_k = top_k

    def setup_vector_store(self, documents, chunk_size: int = 600):
        text_splitter = RecursiveCharacterTextSplitter(
            chunk_size=chunk_size,
            chunk_overlap=100,
            separators=["\n\n", "\n", "### ", "## ", "- ", ".", "!", "?", ",", " "],
        )
        splits = text_splitter.split_documents(documents)
        self.vector_store = Chroma.from_documents(
            documents=splits,
            embedding=self.embeddings,
            persist_directory=self.persist_directory,
        )

    def load_documents(self):
        if not os.path.exists(self.data_dir):
            print(f"Warning: Data directory {self.data_dir} does not exist!")
            return []
        loader = DirectoryLoader(self.data_dir, glob="**/*.md")
        documents = loader.load()
        print(f"Loaded {len(documents)} documents from {self.data_dir}")
        return documents

    def initialize_rag(self, rebuild: bool = False):
        print("Initializing RAG system...")
        print(f"Data directory: {self.data_dir}")
        
        if os.path.exists(self.persist_directory) and not rebuild:
            self.vector_store = Chroma(
                persist_directory=self.persist_directory,
                embedding_function=self.embeddings,
            )
            print("Using existing vector store from:", self.persist_directory)
        else:
            if os.path.exists(self.persist_directory):
                print(f"Deleting existing vector store at {self.persist_directory}...")
                shutil.rmtree(self.persist_directory)
            documents = self.load_documents()
            if not documents:
                print("No documents found to build vector store. RAG not initialized.")
                return False
            self.setup_vector_store(documents)
            print("RAG system initialized successfully!")

        self.retriever = self.vector_store.as_retriever(
            search_type="similarity_score_threshold",
            search_kwargs={
                "k": self.top_k,
                "score_threshold": self.similarity_threshold,
            },
        )
        return True
    
    def retrieve_context(self, query: str, lang_code: str = "id"):
        if not self.retriever:
            raise ValueError("Retriever not initialized. Call initialize_rag() first.")
        try:
            if lang_code != 'id':
                print(f'Translating query from {Language.get(lang_code).display_name()} to Indonesian...')
                response = requests.post("http://localhost:8003/translate", 
                    json={
                        "q": query,
                        "source": lang_code,
                        "target": "id",
                        "format": "text",
                        "alternatives": 3,
                        "api_key": ""
                    },
                    headers={"Content-Type": "application/json"}
                )
                
                translation_result = response.json()
                query = translation_result.get('translatedText', query)
            
            context_docs = self.retriever.invoke(query)
            print(f"Retrieved {len(context_docs)} relevant documents for query: {query}")
            return context_docs
        except Exception as e:
            print(f"Error retrieving context: {e}")
            return []

    def create_prompt(self, lang_code, query, user_id, age: int):
        if self.retriever:
            context_docs = self.retrieve_context(query, lang_code)
        context = [doc.page_content for doc in context_docs]

        if not context:
            context = ["No relevant context found."]

        # Get lang_code display name from code
        language = Language.get(lang_code).display_name()
        
        output_format = StoryInstructions.build_output_format_template(
            user_id=user_id, age_group=age, language=language
        )
        structure_rules = StoryInstructions.build_story_structure_rules(age)

        prompt = ChatPromptTemplate.from_template(PROMPT_TEMPLATE)
        formatted_prompt = prompt.format_prompt(
            context="\n".join(context),
            query=query,
            age=age,
            output_format=output_format,
            structure_rules=structure_rules,
            language=language,
        )
        return formatted_prompt


# Create test instance
if __name__ == "__main__":
    rag_system = IndonesianStoryRAG(data_dir="knowledge_base")
    rag_system.initialize_rag(rebuild=True)
    print("RAG system initialized and ready to use.")

    prompt_id = rag_system.create_prompt(
        lang_code="id",
        query="Ceritakan tentang pentingnya memiliki rasa empati kepada sesama dengan karakter binatang-binatang di hutan",
        user_id="user123",
        age=7,
    )
    print("--- Indonesian Prompt ---")
    print(prompt_id.to_messages())

    print("\n" + "=" * 50 + "\n")

    prompt_en = rag_system.create_prompt(
        lang_code="en",
        query="Tell a story about the importance of empathy with forest animal characters.",
        user_id="user456",
        age=7,
    )
    print("--- English Prompt ---")
    print(prompt_en.to_messages())