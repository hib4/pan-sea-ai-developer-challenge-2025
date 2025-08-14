import os
import shutil
from langchain_text_splitters import RecursiveCharacterTextSplitter
from langchain_community.document_loaders import DirectoryLoader
from langchain_chroma import Chroma
from langchain_openai import OpenAIEmbeddings
from langchain.prompts import ChatPromptTemplate
import json
from dotenv import load_dotenv

load_dotenv()  # Load environment variables from .env file


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
        """
        Create vector store and set up retriever
        """
        # Split documents into chunks
        text_splitter = RecursiveCharacterTextSplitter(
            chunk_size=chunk_size,
            chunk_overlap=100,
            separators=["\n\n", "\n", "### ", "## ", "- ", ".", "!", "?", ",", " "],
        )

        splits = text_splitter.split_documents(documents)

        # Create vector store
        self.vector_store = Chroma.from_documents(
            documents=splits,
            embedding=self.embeddings,
            persist_directory=self.persist_directory,
        )

    @staticmethod
    def build_output_format_template(user_id, age_group, language):
        """
        Build the output format template for the story
        """
        print("Building output format template...")
        return json.dumps(
            {
                "user_id": user_id,
                "title": f"<LLM will fill the title in {language}>",
                "theme": [
                    """
                    Honesty, Responsibility, Discipline, Empathy, Respect, Tolerance, Cooperation, 
                    Caring, Justice, Courage, Humility, Perseverance, Never Give Up, 
                    Trustworthiness, Mutual Cooperation, Politeness, Sportsmanship, Gratitude, 
                    Communication, Problem Solving, Decision Making, Time Management, Self Control, 
                    Emotional Management, Conflict Resolution, Teamwork, Critical Thinking, Creativity, Digital Literacy, 
                    Online Safety, Social Media Ethics, Personal Hygiene, Basic Health, Self Awareness, 
                    Goal Planning
                    """,
                    "<choose 1 - 3 appropriate themes from the list, ensure they are consistent with the list, return as a list>",
                ],
                "language": f"{language}",
                "status": "not_started",
                "age_group": age_group,
                "current_scene": 1,
                "created_at": None,
                "finished_at": None,
                "maximum_point": "<LLM will fill the maximum points (integer)>",
                "story_flow": {"total_scene": 0, "decision_point": [], "ending": []},
                "cover_img_url": None,
                "cover_img_description": "<create a cover image description in English>",
                "description": f"<create a story description in {language}>",
                "estimated_reading_time": "<estimated reading time in seconds (integer)>",
                "characters": [
                    {
                        "name": "create a character name with a culturally relevant name in Indonesia",
                        "description": "<create a character description in English, including physical traits, personality, and role in the story>",
                    },
                    "<add other characters as needed, min 2, max 5. Ensure all characters in the story are defined here, including main and supporting characters>",
                ],
                "scene": [
                    {
                        "scene_id": 1,
                        "type": "narrative",
                        "img_url": None,
                        "img_description": "<create an image description for the scene in English>",
                        "voice_url": None,
                        "content": f"<fill in the story content for the scene in {language}>",
                        "next_scene": "<create the next scene number (integer)>",
                    },
                    {
                        "scene_id": 2,
                        "type": "decision_point",
                        "img_url": None,
                        "img_description": "<create an image description for the scene in English>",
                        "voice_url": None,
                        "content": f"<fill in the story content for the scene in {language}>",
                        "branch": [
                            {
                                "choice": "good",
                                "content": f"<create the choice text in {language}, this choice is either positive or negative>",
                                "moral_value": f"<create the moral value for the choice in {language}>",
                                "point": "<create the points for the choice, can be positive or negative (integer)>",
                                "next_scene": "<create the next scene number based on the choice (integer)>",
                            },
                            {
                                "choice": "bad",
                                "content": f"<create the choice text in {language}, this choice is either negative or positive>",
                                "moral_value": f"<create the moral value for the choice in {language}>",
                                "point": "<create the points for the choice, can be positive or negative (integer)>",
                                "next_scene": "<create the next scene number based on the choice (integer)>",
                            },
                        ],
                        "selected_choice": None,
                    },
                    {
                        "scene_id": 3,
                        "type": "ending",
                        "img_url": None,
                        "img_description": "<create an image description for the scene in English>",
                        "voice_url": None,
                        "content": f"<fill in the story content for the scene in {language}>",
                        "lesson_learned": f"<create the lesson learned from the story in {language}>",
                    },
                    "<more scenes can be added here>",
                ],
                "user_story": {
                    "visited_scene": [],
                    "choices": [],
                    "total_point": 0,
                    "finished_time": 0,
                },
            },
            indent=4,
        )

    def load_documents(self):
        """
        Load documents from the data directory
        """
        if not os.path.exists(self.data_dir):
            print(f"Warning: Data directory {self.data_dir} does not exist!")
            return []

        # Load documents from directory
        loader = DirectoryLoader(self.data_dir, glob="**/*.md")
        documents = loader.load()

        print(f"Loaded {len(documents)} documents from {self.data_dir}")
        return documents

    def initialize_rag(self, rebuild: bool = False):
        """
        Initialize the complete RAG system
        """
        print("Initializing RAG system...")
        print(f"Data directory: {self.data_dir}")
        
        # Setup retriever
        self.retriever = self.vector_store.as_retriever(
            search_type="similarity_score_threshold",
            search_kwargs={
                "k": self.top_k,
                "score_threshold": self.similarity_threshold,
            },
        )
        
        if os.path.exists(self.persist_directory) and not rebuild:
            self.vector_store = Chroma(
                persist_directory=self.persist_directory,
                embedding_function=self.embeddings,
            )
            print("Using existing vector store from:", self.persist_directory)
            return True
        else:
            # Setup fresh vector store
            documents = self.load_documents()
            self.setup_vector_store(documents)
            print("RAG system initialized successfully!")
            return True

    @staticmethod
    def build_story_structure_rules(age_group: int) -> str:
        if 4 <= age_group <= 5:
            return (
                "Create a story with a total of 5 scenes:\n"
                "- Scene 1: opening narrative\n"
                "- Scene 2: development\n"
                "- Scene 3: decision point (child chooses good/bad)\n"
                "- Scene 4 & 5: each is an ending based on the choice\n"
            )
        elif 6 <= age_group <= 12:
            return (
                "Create a story with a total of 10 scenes:\n"
                "- Scene 1: opening narrative\n"
                "- Scene 2: first decision point\n"
                "  - Good choice -> scene 3 (provide a reward here) -> scene 4\n"
                "  - Bad choice -> scene 5 (provide a correction or consequence here) -> scene 6\n"
                "- Scene 4: second decision point for the good branch\n"
                "  - Good choice -> scene 7 (best ending)\n"
                "  - Bad choice -> scene 8 (a decent ending)\n"
                "- Scene 6: second decision point for the bad branch\n"
                "  - Good choice -> scene 9 (a somewhat bad ending)\n"
                "  - Bad choice -> scene 10 (worst ending)\n"
            )
        else:
            return "Use the default 10-scene structure."

    def create_prompt(self, language, query, user_id, age: int):
        PROMPT_TEMPLATE = """
        You are an expert storyteller specializing in teaching **general moral values** and **basic life skills** to children.

        Generate a JSON-formatted interactive story in {language} for children aged {age}. The story should have:
        - Character names and culturally relevant settings based on the requested language and query
        - Two decision points (unless otherwise noted), each with two choices, that affect the story ending

        You can use the following story contexts and examples as inspiration for your story, but you are not limited to it. Feel free to create engaging and educational content based on the query provided.

        ### Context:
        {context}
        
        ### Query:
        {query}

        ### Story Structure Instructions:
        {structure_rules}

        ### General Instructions:
        1. Use simple and engaging language suitable for age {age} in the requested language
        2. Scene types must be: "narrative", "decision_point", or "ending"
        3. Choices should lead to consequences that are constructive but realistic
        4. Provide at least two different endings with different moral outcomes
        5. Do not include markdown or explanations—just clean JSON
        6. For higher age groups (11 - 12), the decision points can be more like a quiz to test their understanding for the said concept.
        7. The story title, description, character names, and all story content must be in the requested language.
        8. The character descriptions, image descriptions, and cover image description must be in English.

        ### Format:
        {output_format}
        """

        # Get relevant context from retriever
        context_docs = []
        if self.retriever:
            try:
                context_docs = self.retriever.invoke(query)
                print(f"Retrieved {len(context_docs)} relevant documents")

                # Extract content from documents
                context = [doc.page_content for doc in context_docs]
            except Exception as e:
                print(f"Error retrieving documents: {e}")
                context = ["No relevant context found."]
        else:
            print(
                "Retriever not initialized. Make sure to call initialize_rag() first."
            )
            context = ["No relevant context found."]

        if not context:
            context = ["No relevant context found."]

        output_format = self.build_output_format_template(
            user_id=user_id, age_group=age, language=language
        )
        structure_rules = self.build_story_structure_rules(age)

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
    rag_system = IndonesianStoryRAG(
        data_dir="knowledge_base"
    )
    rag_system.initialize_rag(rebuild=True)
    print("RAG system initialized and ready to use.")

    # Example usage with Indonesian
    prompt_id = rag_system.create_prompt(
        language="indonesian",
        query="Ceritakan tentang pentingnya memiliki rasa empati kepada sesama dengan karakter binatang-binatang di hutan",
        user_id="user123",
        age=7,
    )
    print("--- Indonesian Prompt ---")
    print(prompt_id.to_messages())

    print("\n" + "=" * 50 + "\n")

    # Example usage with English
    prompt_en = rag_system.create_prompt(
        language="english",
        query="Tell a story about the importance of empathy with forest animal characters.",
        user_id="user456",
        age=7,
    )
    print("--- English Prompt ---")
    print(prompt_en.to_messages())
