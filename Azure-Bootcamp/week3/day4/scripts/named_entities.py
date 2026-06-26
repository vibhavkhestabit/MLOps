import os
from azure.core.credentials import AzureKeyCredential
from azure.ai.textanalytics import TextAnalyticsClient

endpoint = os.getenv("AI_ENDPOINT")
key = os.getenv("AI_KEY")

credential = AzureKeyCredential(key)
client = TextAnalyticsClient(
    endpoint=endpoint,
    credential=credential
)

with open("data/sample-text.txt") as f:
    text = f.read()

response = client.recognize_entities(
    documents=[text]
)

print("\n===== ENTITIES =====\n")

for document in response:
    for entity in document.entities:
        print(
            f"{entity.text} "
            f"({entity.category}) "
            f"confidence={entity.confidence_score:.2f}"
        )