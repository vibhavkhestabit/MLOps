import os
import sys
import time
import requests

endpoint = os.getenv("AI_ENDPOINT")
key = os.getenv("AI_KEY")

if len(sys.argv) != 2:
    print("Usage: python scripts/ocr_pipeline.py <image-path>")
    sys.exit(1)

image_path = sys.argv[1]

with open(image_path, "rb") as f:
    image_data = f.read()

headers = {
    "Ocp-Apim-Subscription-Key": key,
    "Content-Type": "application/octet-stream"
}

response = requests.post(
    f"{endpoint}vision/v3.2/read/analyze",
    headers=headers,
    data=image_data
)

response.raise_for_status()

operation_url = response.headers["Operation-Location"]

print("OCR job submitted...")
print("Operation URL:", operation_url)

while True:
    result = requests.get(
        operation_url,
        headers={"Ocp-Apim-Subscription-Key": key}
    ).json()

    status = result["status"]

    if status in ["succeeded", "failed"]:
        break

    time.sleep(1)

if status == "succeeded":
    print("\n===== STRUCTURED OCR OUTPUT =====\n")

    for page in result["analyzeResult"]["readResults"]:
        print(f"Page {page['page']}")

        for line in page["lines"]:
            print(line["text"])
else:
    print("OCR failed.")