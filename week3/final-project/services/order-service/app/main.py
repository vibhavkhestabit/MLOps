from fastapi import FastAPI

app = FastAPI()

@app.get("/health")
def health():
    return {
        "status": "OK",
        "service": "order-service"
    }

@app.get("/")
def root():
    return {
        "message": "Order Service Running"
    }
