import os
import numpy as np
from openai import AzureOpenAI

client = AzureOpenAI(
    api_key=os.getenv("AZURE_OPENAI_KEY"),
    api_version="2024-10-21",
    azure_endpoint=os.getenv("AZURE_OPENAI_ENDPOINT")
)

texts = [
    "docker run nginx",
    "I live in India"
]

embeddings = []

for text in texts:
    response = client.embeddings.create(
        model="text-embedding-3-small",
        input=text
    )
    embeddings.append(
        np.array(response.data[0].embedding)
    )

similarity = np.dot(
    embeddings[0],
    embeddings[1]
) / (
    np.linalg.norm(embeddings[0]) *
    np.linalg.norm(embeddings[1])
)

print(f"Similarity Score: {similarity:.4f}")