import os
import sys
import time
import requests

ENDPOINT = os.getenv("AI_ENDPOINT")
KEY = os.getenv("AI_KEY")

if not ENDPOINT or not KEY:
    raise ValueError("Please set AI_ENDPOINT and AI_KEY")

if len(sys.argv) != 2:
    print("Usage:")
    print("python ocr.py <image-path>")
    sys.exit(1)

image_path = sys.argv[1]

read_url = f"{ENDPOINT}vision/v3.2/read/analyze"

headers = {
    "Ocp-Apim-Subscription-Key": KEY,
    "Content-Type": "application/octet-stream"
}

with open(image_path, "rb") as image_file:
    response = requests.post(
        read_url,
        headers=headers,
        data=image_file
    )

response.raise_for_status()

operation_url = response.headers["Operation-Location"]

print("OCR job submitted...")
print(f"Operation URL: {operation_url}")

while True:
    result = requests.get(
        operation_url,
        headers={"Ocp-Apim-Subscription-Key": KEY}
    ).json()

    status = result["status"]

    if status == "succeeded":
        break
    elif status == "failed":
        raise Exception("OCR failed")

    time.sleep(1)

print("\n===== EXTRACTED TEXT =====\n")

for page in result["analyzeResult"]["readResults"]:
    for line in page["lines"]:
        print(line["text"])