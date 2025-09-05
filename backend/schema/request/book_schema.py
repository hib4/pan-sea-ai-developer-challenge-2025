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
    CAMBODIA    = "KH"
    EAST_TIMOR  = "TL"
    INDONESIA   = "ID"
    LAOS        = "LA"
    MALAYSIA    = "MY"
    MYANMAR     = "MM"
    PHILIPINES  = "PH"
    SINGAPORE   = "SG"
    THAILAND    = "TH"
    VIETNAM     = "VN"
  
class create_book_schema(BaseModel):
    query: str
    age: int
    voice_name_code: str = "en-US-Chirp3-HD-Achernar"
    language: language_enum = language_enum.ENGLISH
    country: language_enum

class get_book_by_id_schema(BaseModel):
    id: str