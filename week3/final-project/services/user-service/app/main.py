from fastapi import FastAPI
from .database import engine
from .models import Base
from prometheus_fastapi_instrumentator import Instrumentator

Base.metadata.create_all(bind=engine)

app = FastAPI()

Instrumentator().instrument(app).expose(app)

@app.get("/health")
def health():
    return {
        "status": "OK",
        "service": "user-service"
    }

@app.get("/")
def root():
    return {
        "message": "User Service Running"
    }

@app.get("/users")
def get_users():
    return [
        {
            "id": 1,
            "name": "Vibhav",
            "email": "vibhav@example.com"
        }
    ]