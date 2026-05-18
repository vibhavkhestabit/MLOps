from fastapi import FastAPI
from datetime import datetime
import os

app = FastAPI()

@app.get("/")
def home():
    return {
        "message": "FastAPI Docker App Running 🚀"
    }

@app.get("/health")
def health():
    return {
        "status": "healthy",
        "timestamp": datetime.now(),
        "environment": os.getenv("ENVIRONMENT", "development")
    }