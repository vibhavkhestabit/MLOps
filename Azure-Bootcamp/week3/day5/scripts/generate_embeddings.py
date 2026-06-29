import os
import json
import numpy as np
from openai import AzureOpenAI

CHAT_MODEL = os.getenv(
    "AZURE_OPENAI_DEPLOYMENT"
)

EMBEDDING_MODEL = os.getenv(
    "AZURE_OPENAI_EMBEDDING_MODEL"
)

client = AzureOpenAI(
    api_key=os.getenv("AZURE_OPENAI_KEY"),
    api_version=os.getenv("AZURE_OPENAI_API_VERSION"),
    azure_endpoint=os.getenv("AZURE_OPENAI_ENDPOINT")
)

with open(
    "vector_store/chunks.json",
    "r",
    encoding="utf-8"
) as f:
    chunks = json.load(f)

embeddings = []

for i, chunk in enumerate(chunks):
    print(
        f"Embedding chunk {i+1}/{len(chunks)}"
    )

    response = client.embeddings.create(
        model=EMBEDDING_MODEL,
        input=chunk
    )

    embeddings.append(
        response.data[0].embedding
    )

np.save(
    "vector_store/embeddings.npy",
    np.array(embeddings)
)

print("\nEmbeddings saved.")