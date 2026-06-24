#!/bin/bash

set -e

echo "===== Azure AI Services Demo ====="

if [[ -z "$AI_ENDPOINT" || -z "$AI_KEY" ]]; then
  echo "Please export AI_ENDPOINT and AI_KEY first."
  exit 1
fi

echo
echo "===== Sentiment Analysis ====="

curl -s -X POST \
"$AI_ENDPOINT/language/:analyze-text?api-version=2024-11-01" \
-H "Content-Type: application/json" \
-H "Ocp-Apim-Subscription-Key: $AI_KEY" \
-d '{
  "kind":"SentimentAnalysis",
  "analysisInput":{
    "documents":[
      {
        "id":"1",
        "language":"en",
        "text":"I absolutely love Azure AI services and this bootcamp is amazing."
      }
    ]
  }
}' | jq

echo
echo "===== Translator ====="

curl -s -X POST \
"$AI_ENDPOINT/translator/text/v3.0/translate?to=fr&to=es&to=hi" \
-H "Content-Type: application/json" \
-H "Ocp-Apim-Subscription-Key: $AI_KEY" \
-d '[
  {
    "Text":"Hello everyone. Welcome to our Azure AI bootcamp."
  }
]' | jq

echo
echo "===== Computer Vision ====="

curl -s -X POST \
"$AI_ENDPOINT/computervision/imageanalysis:analyze?features=caption,tags&api-version=2024-02-01" \
-H "Content-Type: application/json" \
-H "Ocp-Apim-Subscription-Key: $AI_KEY" \
-d '{
  "url":"https://upload.wikimedia.org/wikipedia/commons/3/3a/Cat03.jpg"
}' | jq

echo
echo "===== Demo Completed ====="