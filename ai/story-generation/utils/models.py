# Request models
from typing import List, Optional, Dict, Any
from pydantic import BaseModel, Field

class StoryRequest(BaseModel):
    query: str = Field(description="Story request in Indonesian", examples=["Cerita tentang menabung"])
    user_id: str = Field(examples=["user123"], description="Unique identifier for the user")
    age: int = Field(description="Age of the child")
    lang_code: str = Field(default="indonesian", description="Language code for the story", examples=["id", "en"])
    country_code: str = Field(default="ID", description="ISO country code for retrieval strategy routing")

# Response models
class Character(BaseModel):
    name: str
    description: str

class Choice(BaseModel):
    choice: str
    content: str
    moral_value: str
    point: int
    next_scene: int

class Scene(BaseModel):
    scene_id: int
    type: str  # "narrative", "decision_point", "ending"
    img_url: Optional[str] = None
    img_description: Optional[str] = None
    voice_url: Optional[str] = None
    content: str
    next_scene: Optional[int] = None
    branch: Optional[List[Choice]] = None
    lesson_learned: Optional[str] = None
    selected_choice: Optional[str] = None  # For decision_point scenes
    ending_type: Optional[str] = None  # For ending scenes, can be "good" or "bad"
    moral_value: Optional[str] = None  # For ending scenes
    meaning: Optional[str] = None  # For ending scenes
    example: Optional[str] = None  # For ending scenes

class StoryResponse(BaseModel):
    user_id: str
    title: str
    theme: List[str]
    language: str
    status: str
    age_group: int
    current_scene: int
    created_at: Optional[str] = None
    finished_at: Optional[str] = None
    maximum_point: int
    story_flow: Dict[str, Any]
    characters: List[Character]
    scene: List[Scene]
    user_story: Dict[str, Any]
    cover_img_url: Optional[str] = None
    cover_img_description: Optional[str] = ""
    description: str = "A story about being kind to others."
    estimated_reading_time: int = 600  # Default to 5 minutes in seconds