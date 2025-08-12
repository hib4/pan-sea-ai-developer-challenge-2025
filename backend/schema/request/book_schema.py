from pydantic import BaseModel
from enum import Enum

class language_enum(str, Enum):
    ENGLISH = "english"
    INDONESIAN = "indonesian"

class create_book_schema(BaseModel):
    query: str
    age: int
    voice_name_code: str = "en-US-JennyMultilingualNeural"
    language: language_enum = language_enum.ENGLISH

class get_book_by_id_schema(BaseModel):
    id: str