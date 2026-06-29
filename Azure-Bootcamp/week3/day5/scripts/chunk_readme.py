import os
import json

README_FILE = "data/week1_README.md"

with open(README_FILE, "r", encoding="utf-8") as f:
    text = f.read()

CHUNK_SIZE = 800
OVERLAP = 200

chunks = []

for i in range(
    0,
    len(text),
    CHUNK_SIZE - OVERLAP
):
    chunk = text[i:i + CHUNK_SIZE]

    if chunk.strip():
        chunks.append(chunk)

os.makedirs("vector_store", exist_ok=True)

with open(
    "vector_store/chunks.json",
    "w",
    encoding="utf-8"
) as f:
    json.dump(
        chunks,
        f,
        indent=2,
        ensure_ascii=False
    )

print(f"Created {len(chunks)} chunks.")