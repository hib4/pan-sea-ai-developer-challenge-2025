from fastapi import APIRouter, Depends
from middleware.auth_middleware import get_current_user
from handler.country_handler import get_available_country
router = APIRouter()

@router.get("/api/v1/countries")
def get_voice_model(current_user=Depends(get_current_user)):
    return get_available_country(current_user)