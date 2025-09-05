from fastapi import APIRouter
from handler import health_check_handler
router = APIRouter()

@router.get("/ping") 
def health_check():
    return health_check_handler.health_check()