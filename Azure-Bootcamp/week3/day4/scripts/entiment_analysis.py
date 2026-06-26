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

response = client.analyze_sentiment(
    documents=[text]
)

for document in response:
    print("\n===== SENTIMENT =====\n")
    print("Overall sentiment:", document.sentiment)

    print("\nConfidence Scores:")
    print("Positive:", document.confidence_scores.positive)
    print("Neutral :", document.confidence_scores.neutral)
    print("Negative:", document.confidence_scores.negative)