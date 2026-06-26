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

response = client.extract_key_phrases(
    documents=[text]
)

print("\n===== KEY PHRASES =====\n")

for document in response:
    for phrase in document.key_phrases:
        print("-", phrase)