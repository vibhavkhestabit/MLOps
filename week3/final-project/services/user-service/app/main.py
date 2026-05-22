from fastapi import FastAPI

app = FastAPI()

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