import os
from openai import AzureOpenAI

client = AzureOpenAI(
    api_key=os.getenv("AZURE_OPENAI_KEY"),
    api_version=os.getenv("AZURE_OPENAI_API_VERSION"),
    azure_endpoint=os.getenv("AZURE_OPENAI_ENDPOINT")
)

texts = [
    "docker run nginx",
    "run a docker container using nginx"
]

for text in texts:
    response = client.embeddings.create(
        model=os.getenv("AZURE_OPENAI_EMBEDDING_MODEL"),
        input=text
    )

    embedding = response.data[0].embedding

    print("\nText:")
    print(text)

    print("\nEmbedding Dimensions:")
    print(len(embedding))

    print("\nFirst 10 numbers:")
    print(embedding[:10])