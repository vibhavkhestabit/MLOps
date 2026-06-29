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

embeddings = np.load(
    "vector_store/embeddings.npy"
)


def cosine_similarity(a, b):
    return np.dot(a, b) / (
        np.linalg.norm(a)
        * np.linalg.norm(b)
    )


while True:
    question = input(
        "\nAsk a question (exit to quit): "
    )

    if question.lower() == "exit":
        break

    print(
        "\nGenerating question embedding..."
    )

    response = client.embeddings.create(
        model=EMBEDDING_MODEL,
        input=question
    )

    question_embedding = np.array(
        response.data[0].embedding
    )

    scores = []

    for i, emb in enumerate(embeddings):
        score = cosine_similarity(
            question_embedding,
            emb
        )

        scores.append((score, i))

    scores.sort(
        key=lambda x: x[0],
        reverse=True
    )

    top_chunks = "\n\n".join(
        chunks[i]
        for _, i in scores[:3]
    )

    print(
        "\n===== RETRIEVED CONTEXT =====\n"
    )
    print(top_chunks[:1000])

    prompt = f"""
You are answering questions about the
Week 1 Azure project.

Answer ONLY from the context below.

If the answer is not present in the
context, say:

'I could not find that information
in the provided documentation.'

Context:
{top_chunks}

Question:
{question}
"""

    answer = client.responses.create(
        model=CHAT_MODEL,
        input=prompt
    )

    print("\n===== ANSWER =====\n")

    for item in answer.output:
        if item.type == "message":
            for content in item.content:
                if content.type == "output_text":
                    print(content.text)