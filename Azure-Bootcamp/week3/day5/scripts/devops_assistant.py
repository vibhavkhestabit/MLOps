import os
from openai import AzureOpenAI

client = AzureOpenAI(
    api_key=os.getenv("AZURE_OPENAI_KEY"),
    api_version=os.getenv("AZURE_OPENAI_API_VERSION"),
    azure_endpoint=os.getenv("AZURE_OPENAI_ENDPOINT")
)

system_prompt = """
You are a Senior DevOps Engineer.

Responsibilities:
1. Explain infrastructure errors clearly.
2. Identify the probable root cause.
3. Suggest step-by-step fixes.
4. Mention relevant kubectl or docker commands.
5. Keep answers concise and practical.
"""

user_prompt = """
Pod nginx-app-7f4d6f failed with:

ImagePullBackOff

Events:
Failed to pull image 'nginx:latesttt'
repository does not exist.
"""

response = client.responses.create(
    model=os.getenv("AZURE_OPENAI_DEPLOYMENT"),
    instructions=system_prompt,
    input=user_prompt
)

print("\n===== DEVOPS ASSISTANT =====\n")

for item in response.output:
    if item.type == "message":
        for content in item.content:
            if content.type == "output_text":
                print(content.text)