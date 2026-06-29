import os
from openai import AzureOpenAI

client = AzureOpenAI(
    azure_endpoint=os.environ["AOAI_ENDPOINT"],
    api_key=os.environ["AOAI_KEY"],
    api_version="2025-04-01-preview"
)

response = client.responses.create(
    model=os.environ["AOAI_DEPLOYMENT"],
    input="Explain Kubernetes in one paragraph."
)

print("\n===== RESPONSE =====\n")
print(response.output_text)