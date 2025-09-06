# app.py (only showing changed imports & replaced calls at bottom)

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field, SecretStr
from typing import Optional, List, Dict, Any
import uvicorn
import json
from rag import IndonesianStoryRAG
from langchain_openai import ChatOpenAI
from fastapi.middleware.cors import CORSMiddleware
from dotenv import load_dotenv
import os

# NEW: use our utils (models, cleaner, validator)
from utils.models import StoryRequest, StoryResponse, Scene, Choice, Character
from utils.json_cleaner import clean_json_response
from utils.story_validator import StoryValidator

load_dotenv()

# (REMOVE the inline StoryRequest/StoryResponse/etc. definitions)

# Create FastAPI instance (unchanged)
app = FastAPI(
    title="Indonesian Storytelling API",
    description="Generate interactive stories for children's education",
    version="1.0.0"
)

# CORS (unchanged)
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize your RAG system (unchanged for Step 1)
rag = IndonesianStoryRAG(
    data_dir='./knowledge_base',
)
rag.initialize_rag(rebuild=True)

chat_model = ChatOpenAI(
    model=os.getenv("LLM_MODEL", "aisingapore/Llama-SEA-LION-v3.5-70B-R"),
    temperature=0.7,
    api_key=SecretStr(os.getenv("SEALION_API_KEY", "")),
    base_url="https://api.sea-lion.ai/v1"
)

def convert_age_to_range(age: int) -> str:
    # unchanged
    if age <= 5:
        return "4-5"
    elif age <= 7:
        return "6-7"
    elif age <= 9:
        return "7-9"
    elif age <= 12:
        return "10-12"
    else:
        return "7-9"

@app.post("/generate-story", response_model=StoryResponse)
async def generate_story(request: StoryRequest):
    try:
        # Build prompt with your current RAG system (Step 1 keeps old flow)
        prompt = rag.create_prompt(
            query=request.query,
            user_id=request.user_id,
            age=request.age,
            lang_code=request.lang_code
        )

        # Get response from LLM
        print(f"Generating story for user {request.user_id} with age {request.age}...")
        response = chat_model.invoke(prompt)

        # Parse story JSON
        if response:
            content = str(response.content)
            story_json = clean_json_response(content)

        print('Validating story content...')
        # Validate / standardize
        story_json = StoryValidator.validate(story_json, request.user_id, request.age)

        print(f"Generated story for user {request.user_id} with age {request.age}: {story_json['title']}")
        return StoryResponse(**story_json)

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Story generation failed: {str(e)}")

@app.get("/")
async def root():
    return {"message": "Indonesian Moral Value Story API is running!"}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8001)