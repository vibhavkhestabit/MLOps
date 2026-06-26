import os
from azure.core.credentials import AzureKeyCredential
from azure.ai.formrecognizer import DocumentAnalysisClient

endpoint = os.getenv("DOCINTEL_ENDPOINT")
key = os.getenv("DOCINTEL_KEY")

client = DocumentAnalysisClient(
    endpoint=endpoint,
    credential=AzureKeyCredential(key)
)

with open("data/sample-invoice.pdf", "rb") as f:
    poller = client.begin_analyze_document(
        "prebuilt-invoice",
        document=f
    )

result = poller.result()

print("\n===== INVOICE FIELDS =====\n")

for invoice in result.documents:
    for name, field in invoice.fields.items():
        value = field.value if field.value else field.content
        print(f"{name}: {value}")