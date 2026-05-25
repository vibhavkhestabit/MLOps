from fastapi import FastAPI
from prometheus_fastapi_instrumentator import Instrumentator

app = FastAPI()

Instrumentator().instrument(app).expose(app)

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

@app.get("/orders")
def get_orders():
    return [
        {
            "id": 1,
            "product": "Laptop",
            "quantity": 1
        }
    ]