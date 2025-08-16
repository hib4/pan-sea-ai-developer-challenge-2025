import json
import os
from langchain_openai import ChatOpenAI
from langchain.prompts import ChatPromptTemplate
from dotenv import load_dotenv
from pydantic import SecretStr
from typing import Dict, List, Any
from chatbot_instructions import PROMPT_TEMPLATE_INTENT_CLASSIFIER

load_dotenv()


class IntentClassifier:
    """
    A dedicated class for classifying user intent and extracting relevant parameters
    for backend API calls.
    """

    def __init__(self, model_name: str = "gpt-4o-mini"):
        """
        Initializes the IntentClassifier with an LLM for classification.
        """
        api_key = os.getenv("OPENAI_API_KEY")
        self.llm = ChatOpenAI(
            model=model_name,
            temperature=0.1,  # Lower temperature for more deterministic responses
            api_key=SecretStr(api_key) if api_key else None,
        )
        # Define the exact list of themes for the LLM to choose from, to ensure consistency
        self.themes_list = [
            """
            Honesty, Responsibility, Discipline, Empathy, Respect, Tolerance, Cooperation, 
            Caring, Justice, Courage, Humility, Perseverance, Never Give Up, 
            Trustworthiness, Mutual Cooperation, Politeness, Sportsmanship, Gratitude, 
            Communication, Problem Solving, Decision Making, Time Management, Self Control, 
            Emotional Management, Conflict Resolution, Teamwork, Critical Thinking, Creativity, Digital Literacy, 
            Online Safety, Social Media Ethics, Personal Hygiene, Basic Health, Self Awareness, 
            Goal Planning, Financial Planning, Budgeting, Saving, Investing,
            Spending Wisely, Understanding Needs vs Wants, Financial Responsibility,
            """
        ]

    def classify(self, query: str) -> Dict[str, Any]:
        """
        Classifies the user's query and extracts parameters using the LLM.

        Args:
            query (str): The user's input query.

        Returns:
            dict: Parsed JSON response from the LLM indicating intent and API details.
        """
        prompt_template = ChatPromptTemplate.from_template(PROMPT_TEMPLATE_INTENT_CLASSIFIER)
        formatted_prompt = prompt_template.format_messages(
            query=query, themes_list=", ".join(self.themes_list)
        )
        # Attempt to invoke the LLM with the formatted prompt
        print("Classifying user query...")
        try:
            response = self.llm.invoke(formatted_prompt)
            # Add a check for empty or invalid response content
            content = response.content if isinstance(response.content, str) else str(response.content)
            if not content.strip():
                raise ValueError("LLM returned an empty response.")
            intent_data = json.loads(content.strip())  # type: ignore
            # Print for debugging
            print(f"Intent classification result: {intent_data}")
            return intent_data
        except (json.JSONDecodeError, ValueError) as e:
            print(
                f"An error occurred during JSON parsing or with the LLM response: {e}"
            )
            return {
                "intent": "general_query",
                "api_call_details": [
                    {
                        "api_type": None,
                        "themes": [],
                        "time_unit": None,
                        "num_periods": None,
                        "start_date": None,
                        "end_date": None,
                    }
                ],
            }
        except Exception as e:
            print(f"An unexpected error occurred during intent classification: {e}")
            return {
                "intent": "general_query",
                "api_call_details": [
                    {
                        "api_type": None,
                        "themes": [],
                        "time_unit": None,
                        "num_periods": None,
                        "start_date": None,
                        "end_date": None,
                    }
                ],
            }

# Test instance
if __name__ == "__main__":
    classifier = IntentClassifier()
    test_query = "How is my child's performance in the concept of creativity for the past 3 months?"
    result = classifier.classify(test_query)