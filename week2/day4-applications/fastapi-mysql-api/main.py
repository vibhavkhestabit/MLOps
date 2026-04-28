import time
from fastapi import FastAPI, Depends, HTTPException, Request
from fastapi.responses import JSONResponse
import structlog
from database import get_db
from models import ProductCreate, ProductUpdate
from dotenv import load_dotenv

load_dotenv()

# Setup Enterprise JSON Logging
structlog.configure(
    processors=[
        structlog.processors.TimeStamper(fmt="iso"),
        structlog.processors.JSONRenderer()
    ]
)
logger = structlog.get_logger()

app = FastAPI(title="FastAPI MySQL Inventory API", version="1.0.0")

# Request Logging Middleware
@app.middleware("http")
async def log_requests(request: Request, call_next):
    start_time = time.time()
    response = await call_next(request)
    process_time = (time.time() - start_time) * 1000
    logger.info("request_processed", path=request.url.path, method=request.method, status=response.status_code, duration_ms=round(process_time, 2))
    return response

# Health Check
@app.get("/api/health")
async def health_check(cur = Depends(get_db)):
    try:
        await cur.execute("SELECT 1")
        return {"status": "healthy", "database": "connected"}
    except Exception as e:
        logger.error("health_check_failed", error=str(e))
        return JSONResponse(status_code=503, content={"status": "degraded", "database": "disconnected", "error": str(e)})

# CRUD: Get All Products
@app.get("/api/v1/products")
async def get_products(cur = Depends(get_db)):
    await cur.execute("SELECT * FROM products")
    return await cur.fetchall()

# CRUD: Create Product
@app.post("/api/v1/products", status_code=201)
async def create_product(product: ProductCreate, cur = Depends(get_db)):
    sql = "INSERT INTO products (name, description, price, stock_quantity) VALUES (%s, %s, %s, %s)"
    await cur.execute(sql, (product.name, product.description, product.price, product.stock_quantity))
    await cur.execute("SELECT * FROM products WHERE id = LAST_INSERT_ID()")
    return await cur.fetchone()

# CRUD: Get Single Product
@app.get("/api/v1/products/{id}")
async def get_product(id: int, cur = Depends(get_db)):
    await cur.execute("SELECT * FROM products WHERE id = %s", (id,))
    product = await cur.fetchone()
    if not product:
        raise HTTPException(status_code=404, detail="Product not found")
    return product

# CRUD: Update Product
@app.put("/api/v1/products/{id}")
async def update_product(id: int, product: ProductUpdate, cur = Depends(get_db)):
    await cur.execute("SELECT * FROM products WHERE id = %s", (id,))
    existing = await cur.fetchone()
    if not existing:
        raise HTTPException(status_code=404, detail="Product not found")
    
    update_data = product.dict(exclude_unset=True)
    if not update_data:
        return existing
        
    set_clause = ", ".join([f"{key} = %s" for key in update_data.keys()])
    values = list(update_data.values())
    values.append(id)
    
    await cur.execute(f"UPDATE products SET {set_clause} WHERE id = %s", tuple(values))
    await cur.execute("SELECT * FROM products WHERE id = %s", (id,))
    return await cur.fetchone()

# CRUD: Delete Product
@app.delete("/api/v1/products/{id}")
async def delete_product(id: int, cur = Depends(get_db)):
    await cur.execute("DELETE FROM products WHERE id = %s", (id,))
    if cur.rowcount == 0:
        raise HTTPException(status_code=404, detail="Product not found")
    return {"message": "Product deleted successfully"}