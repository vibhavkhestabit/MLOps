from fastapi import FastAPI

app = FastAPI()

@app.get("/")
def root():
    return {
        "message": "Secure Python App Running"
    }

@app.get("/health")
def health():
    return {
        "status": "healthy"
    }
