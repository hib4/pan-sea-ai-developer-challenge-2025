from pydantic import BaseModel
from enum import Enum

class language_enum(str, Enum):
    ENGLISH     = "en"
    INDONESIA   = "id"
    VIETNAMESE  = "vi"
    THAI        = "th"
    MANDARIN    = "cmn"
    TAMIL       = "ta"

class country_enum(str,Enum):
    BRUNEI      = "bn"
    CAMBODIA    = "kh"
    EAST_TIMOR  = "tl"
    INDONESIA   = "id"
    LAOS        = "la"
    MALAYSIA    = "my"
    MYANMAR     = "mm"
    PHILIPINES  = "ph"
    SINGAPORE   = "sg"
    THAILAND    = "th"
    VIETNAM     = "vn"
  
class create_book_schema(BaseModel):
    query: str
    age: int
    voice_name_code: str = "en-US-Chirp3-HD-Achernar"
    language: language_enum = language_enum.ENGLISH
    country: country_enum

class get_book_by_id_schema(BaseModel):
    id: str