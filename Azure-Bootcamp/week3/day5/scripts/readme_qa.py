import os
from openai import AzureOpenAI

client = AzureOpenAI(
    api_key=os.getenv("AZURE_OPENAI_KEY"),
    api_version=os.getenv("AZURE_OPENAI_API_VERSION"),
    azure_endpoint=os.getenv("AZURE_OPENAI_ENDPOINT")
)

with open("data/week1_README.md", "r") as f:
    readme = f.read()

question = input("Ask a question about Week 1 README:\n> ")

prompt = f"""
You are an assistant that answers ONLY using the information below.

README:
{readme}

Question:
{question}
"""

response = client.responses.create(
    model=os.getenv("AZURE_OPENAI_DEPLOYMENT"),
    input=prompt
)

print("\n===== ANSWER =====\n")

for item in response.output:
    if item.type == "message":
        for content in item.content:
            if content.type == "output_text":
                print(content.text)