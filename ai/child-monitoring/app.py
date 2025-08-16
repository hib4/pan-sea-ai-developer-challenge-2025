from fastapi import FastAPI, HTTPException
from fastapi.responses import StreamingResponse
from fastapi.middleware.cors import CORSMiddleware
from pydantic import BaseModel, Field
from typing import Optional, AsyncGenerator
import json
import asyncio
import os
from contextlib import asynccontextmanager

from langchain_openai import ChatOpenAI
from pydantic import SecretStr
from dotenv import load_dotenv

# Import your existing RAG system
from rag import ChildMonitoringRAG

load_dotenv()

# Global variable to store the RAG system
rag_system = None

@asynccontextmanager
async def lifespan(app: FastAPI):
    """Initialize the RAG system on startup"""
    global rag_system
    
    # Initialize RAG system
    print("Initializing RAG system...")
    rag_system = ChildMonitoringRAG(
        data_dir="knowledge_base/",
        similarity_threshold=0.25,
        top_k=3,
    )
    
    # Initialize the RAG system (this will create/load vector database)
    rag_system.initialize_rag(rebuild=True)
    print("RAG system initialized successfully!")
    
    yield
    
    # Cleanup on shutdown
    print("Shutting down RAG system...")

app = FastAPI(
    title="Child Moral Monitoring Chatbot",
    description="A chatbot system for analyzing children's learning and development patterns, providing actionable advice to parents and educators.",
    version="1.0.0",
    lifespan=lifespan
)

# Add CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Configure appropriately for production
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Initialize the main LLM for final response generation
chat_model = ChatOpenAI(
    model=os.getenv("LLM_MODEL", "aisingapore/Llama-SEA-LION-v3.5-70B-R"),
    temperature=0.4,
    api_key=SecretStr(os.getenv("SEALION_API_KEY", "")),
    base_url="https://api.sea-lion.ai/v1"
)

# Pydantic models for request/response
class ChatRequest(BaseModel):
    message: str = Field(..., description="User's message/question")
    child_age: int = Field(..., ge=3, le=18, description="Child's age in years")
    token: str = Field(..., description="Authentication token for internal use")
    lang_code: str = Field(default="indonesian", description="Language code for the response", examples=["id", "en"])

class ChatResponse(BaseModel):
    response: str

class HealthResponse(BaseModel):
    status: str
    message: str

@app.get("/health", response_model=HealthResponse)
async def health_check():
    """Health check endpoint"""
    return HealthResponse(
        status="healthy",
        message="Child Monitoring Chatbot is running"
    )

@app.get("/")
async def root():
    """Root endpoint with basic info"""
    return {
        "message": "Child Monitoring Chatbot API",
        "version": "1.0.0",
        "endpoints": {
            "chat": "/chat",
            "chat_stream": "/chat/stream",
            "health": "/health"
        }
    }

async def generate_streaming_response(prompt_value) -> AsyncGenerator[str, None]:
    """
    Generate streaming response from the LLM
    """
    try:
        # Stream the response from the LLM
        async for chunk in chat_model.astream(prompt_value.to_messages()):
            if chunk.content:                
                # Format as Server-Sent Events
                data = {
                    "content": chunk.content,
                    "type": "content"
                }
                yield f"data: {json.dumps(data)}\n\n"
                
                # Add small delay to make streaming more visible
                await asyncio.sleep(0.01)
        
        # Send completion signal
        completion_data = {
            "content": "",
            "type": "complete"
        }
        yield f"data: {json.dumps(completion_data)}\n\n"
        
    except Exception as e:
        # Send error signal
        error_data = {
            "content": f"Error generating response: {str(e)}",
            "type": "error"
        }
        yield f"data: {json.dumps(error_data)}\n\n"

@app.post("/chat/stream")
async def chat_stream(request: ChatRequest):
    """
    Stream chat response for real-time chatbot experience
    """
    global rag_system
    
    if not rag_system:
        raise HTTPException(status_code=500, detail="RAG system not initialized")
    
    try:
        # Create the prompt using your RAG system
        prompt_value = rag_system.create_prompt(
            token=request.token,
            query=request.message,
            child_age=request.child_age,
            lang_code=request.lang_code  # Use lang_code for language-specific responses
        )
        
        # Return streaming response
        return StreamingResponse(
            generate_streaming_response(prompt_value),
            media_type="text/plain",
            headers={
                "Cache-Control": "no-cache",
                "Connection": "keep-alive",
                "Content-Type": "text/event-stream",
            }
        )
        
    except Exception as e:
        print(f"Error in chat_stream: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Internal server error: {str(e)}")

@app.post("/chat", response_model=ChatResponse)
async def chat(request: ChatRequest):
    """
    Non-streaming chat endpoint (for cases where streaming is not needed)
    """
    global rag_system
    
    if not rag_system:
        raise HTTPException(status_code=500, detail="RAG system not initialized")
    
    try:
        # Generate the prompt using your RAG system
        print(f"Processing query: {request.message}")
        print(f"Child age: {request.child_age}")
        
        # Create the prompt using your RAG system
        prompt_value = rag_system.create_prompt(
            query=request.message,
            child_age=request.child_age,
            token=request.token,  # Optional token for internal use
            lang_code=request.lang_code  # Use lang_code for language-specific responses
        )
        
        # Get response from LLM (non-streaming)
        response = await chat_model.ainvoke(prompt_value.to_messages())
        
        return ChatResponse(
            response=response.content, # type: ignore
        )
        
    except Exception as e:
        print(f"Error in chat: {str(e)}")
        raise HTTPException(status_code=500, detail=f"Internal server error: {str(e)}")

@app.get("/system/status")
async def system_status():
    """
    Get system status and configuration
    """
    global rag_system
    
    status = {
        "rag_system_initialized": rag_system is not None,
        "vector_db_path": os.getenv("VECTOR_DB_PATH", "vectordb"),
        "knowledge_dir": os.getenv("DATA_DIR", "data/financial_literacy_guide.pdf"),
        "backend_api_url": os.getenv("BACKEND_API_BASE_URL", "http://localhost:8000/api/v1/analytic"),
        "main_llm_model": "gpt-4o",
        "embedding_model": "text-embedding-3-small"
    }
    
    if rag_system:
        status["similarity_threshold"] = rag_system.similarity_threshold
        status["top_k"] = rag_system.top_k
        
        # Check if vector store is ready
        if rag_system.vectorstore:
            try:
                doc_count = rag_system.vectorstore._collection.count()
                status["vector_store_document_count"] = doc_count
                status["vector_store_ready"] = doc_count > 0
            except:
                status["vector_store_ready"] = False
    
    return status

if __name__ == "__main__":
    import uvicorn
    
    # Run the server
    uvicorn.run(
        "app:app",
        host="0.0.0.0",
        port=8002,
        log_level="info"
    )