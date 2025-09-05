import httpx
from fastapi import HTTPException
from fastapi.responses import RedirectResponse
from schema.request.auth_schema import login_schema,register_schema
from models.user import User, AuthProvider
from utils.hash import hash,compare
from datetime import datetime
from utils.jwt import create_access_token
from setting.settings import settings

GOOGLE_CLIENT_ID = settings.GOOGLE_CLIENT_ID
GOOGLE_CLIENT_SECRET = settings.GOOGLE_CLIENT_SECRET
GOOGLE_REDIRECT_URI = settings.GOOGLE_REDIRECT_URI
GOOGLE_OAUTH2_URL =  "https://oauth2.googleapis.com/token"

async def register(body: register_schema):
    user = await User.find_one(User.email == body.email)
    if user:
        raise HTTPException(status_code= 409, detail= f"email {body.email} already register")

    user = User(
        name = body.name,
        email = body.email,
        password = hash(body.password),
        auth = AuthProvider.local,
        google_id = None
    )
    
    await user.insert()

    return {
        "message": f"successfully create new user with id {str(user.id)}"
    }

async def login(body: login_schema):
    user = await User.find_one(User.email == body.email)
    
    if not user:
        raise HTTPException(status_code= 404, detail= f"User with email {body.email} not found")

    if user.auth == AuthProvider.google:
        raise HTTPException(status_code= 404, detail= f"User with email {body.email} not found")

    isMatch = compare(body.password, user.password)

    if not isMatch:
        raise HTTPException(status_code= 401, detail= "Password in correct")

    token = create_access_token(user)

    return {
        "token": token
    }

async def google_login(code):
    data = {
        "code": code,
        "client_id": GOOGLE_CLIENT_ID,
        "client_secret": GOOGLE_CLIENT_SECRET,
        "redirect_uri": GOOGLE_REDIRECT_URI,
        "grant_type": "authorization_code",
    }

    async with httpx.AsyncClient() as client:
        token_resp = await client.post(GOOGLE_OAUTH2_URL, data=data)

    if token_resp.status_code != 200:
        raise HTTPException(status_code=400, detail=token_resp.text)

    token_data = token_resp.json()
    id_token = token_data.get("id_token")
    access_token = token_data.get("access_token")

    if not id_token:
        raise HTTPException(status_code=400, detail="No ID token returned by Google")

    async with httpx.AsyncClient() as client:
        userinfo_resp = await client.get(
            "https://www.googleapis.com/oauth2/v3/userinfo",
            headers={"Authorization": f"Bearer {access_token}"}
        )

    if userinfo_resp.status_code != 200:
        raise HTTPException(status_code=400, detail="Failed to fetch user info")

    profile = userinfo_resp.json()
    google_id = profile["sub"]
    email = profile.get("email")
    name = profile.get("name")

    user = await User.find_one(User.google_id == google_id)

    if not user:
        user = User(
            name=name,
            email=email,
            auth="google",
            google_id=google_id
        )
        await user.insert()   # Beanie requires insert()

    jwt_token = create_access_token(user)

    frontend_redirect = f"{settings.FRONTEND_REDIRECT_URL}?token={jwt_token}"
    return RedirectResponse(url=frontend_redirect)
