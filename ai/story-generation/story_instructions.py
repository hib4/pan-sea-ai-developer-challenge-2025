# story_instructions.py
import json

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
9. Remember to keep the content story in {language} even if the context is in Indonesian.
10. Remember that the ending is only in scene 7, 8, 9, and 10, not other scenes.
11. Make sure that the ending type is only between "good" or "bad", and not anything else.

### Format:
{output_format}
"""


class StoryInstructions:
    @staticmethod
    def build_output_format_template(user_id, age_group, language):
        """
        Build the output format template for the story
        """
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
                        Goal Planning, Financial Planning, Budgeting, Saving, Investing,
                        Spending Wisely, Understanding Needs vs Wants, Financial Responsibility,
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
                        "name": f"<create a character name with a culturally relevant name in {language}>",
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
                        "ending_type": "<good or bad, choose either based on the previous choice>",
                        "img_url": None,
                        "img_description": "<create an image description for the scene in English>",
                        "voice_url": None,
                        "content": f"<fill in the story content for the scene in {language}>",
                        "lesson_learned": f"<create the lesson learned from the story in {language}>",
                        "moral_value": f"<pick one most relevant moral value from the choices in {language}>",
                        "meaning": f"<create the meaning of the moral value in {language}, with format: '<moral value> means <meaning>'>",
                        "example": f"<create an example of the moral value in {language} for real word for kids>",
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
