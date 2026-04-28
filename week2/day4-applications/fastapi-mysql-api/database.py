import os
import aiomysql
from dotenv import load_dotenv

load_dotenv()

pool_config = {
    'host': os.getenv('DB_HOST', 'localhost'),
    'port': int(os.getenv('DB_PORT', 3306)),
    'user': os.getenv('DB_USER'),
    'password': os.getenv('DB_PASSWORD'),
    'db': os.getenv('DB_NAME'),
    'minsize': 5,
    'maxsize': 20,
    'pool_recycle': 3600,
    'autocommit': True,
    'cursorclass': aiomysql.DictCursor # Ensures we get JSON-like dictionaries back, not tuples!
}

db_pool = None

async def get_db_pool():
    global db_pool
    if not db_pool:
        db_pool = await aiomysql.create_pool(**pool_config)
    return db_pool

# Dependency Injection function for our routes
async def get_db():
    pool = await get_db_pool()
    async with pool.acquire() as conn:
        async with conn.cursor() as cur:
            yield cur