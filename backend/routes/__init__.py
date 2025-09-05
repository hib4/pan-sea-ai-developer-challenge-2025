from .auth_router import router as auth_router
from .user_router import router as user_router
from .book_router import router as book_router
from .voice_router import router as voice_router
from .analytic_router import router as analytic_router
from .country_router import router as country_router
from .health_check_router import router as health_check_router

routers = [
    health_check_router,
    auth_router,
    user_router,
    book_router,
    voice_router,
    analytic_router,
    country_router,
]
