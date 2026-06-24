# Week 3 - Day 1 Commands

## Create Resource Group

```bash
az group create \
  --name week3-ai-rg \
  --location eastus
```

---

## Create Azure AI Services Resource (Portal)

Resource Name:

```text
week3-ai-services
```

SKU:

```text
S0
```

---

## Show Resource Information

```bash
az cognitiveservices account show \
  --name week3-ai-services \
  --resource-group week3-ai-rg \
  --query kind
```

```bash
az cognitiveservices account show \
  --name week3-ai-services \
  --resource-group week3-ai-rg \
  --query properties.endpoint
```

---

## Environment Variables

```bash
export AI_ENDPOINT="https://week3-ai-services.cognitiveservices.azure.com/"
export AI_KEY="<your-api-key>"
export LANGUAGE_API_VERSION="2024-11-01"
```

---

# Language Detection

Create payload:

```bash
cat > language.json <<EOF
{
  "kind": "LanguageDetection",
  "analysisInput": {
    "documents": [
      {
        "id": "1",
        "text": "Hola amigo, how are you?"
      }
    ]
  }
}
EOF
```

Run:

```bash
curl -X POST \
"$AI_ENDPOINT/language/:analyze-text?api-version=$LANGUAGE_API_VERSION" \
-H "Content-Type: application/json" \
-H "Ocp-Apim-Subscription-Key: $AI_KEY" \
-d @language.json | jq
```

---

# Sentiment Analysis

Create payload:

```bash
cat > sentiment.json <<EOF
{
  "kind": "SentimentAnalysis",
  "analysisInput": {
    "documents": [
      {
        "id": "1",
        "language": "en",
        "text": "I absolutely love Azure AI services and this bootcamp is amazing."
      }
    ]
  }
}
EOF
```

Run:

```bash
curl -X POST \
"$AI_ENDPOINT/language/:analyze-text?api-version=$LANGUAGE_API_VERSION" \
-H "Content-Type: application/json" \
-H "Ocp-Apim-Subscription-Key: $AI_KEY" \
-d @sentiment.json | jq
```

---

# Translator API

Create payload:

```bash
cat > translate.json <<EOF
[
  {
    "Text": "Hello everyone. Welcome to our Azure AI bootcamp."
  }
]
EOF
```

Run:

```bash
curl -X POST \
"$AI_ENDPOINT/translator/text/v3.0/translate?to=fr&to=es&to=hi" \
-H "Content-Type: application/json" \
-H "Ocp-Apim-Subscription-Key: $AI_KEY" \
-d @translate.json | jq
```

---

# Computer Vision API

```bash
export IMAGE_URL="https://upload.wikimedia.org/wikipedia/commons/3/3a/Cat03.jpg"
```

Create payload:

```bash
cat > image.json <<EOF
{
  "url": "$IMAGE_URL"
}
EOF
```

Run:

```bash
curl -X POST \
"$AI_ENDPOINT/computervision/imageanalysis:analyze?features=caption,tags&api-version=2024-02-01" \
-H "Content-Type: application/json" \
-H "Ocp-Apim-Subscription-Key: $AI_KEY" \
-d @image.json | jq
```

---

# Virtual Environment

Create:

```bash
cd ~/MLOps-Training/Azure-Bootcamp/week3
python3 -m venv .venv
```

Activate:

```bash
source .venv/bin/activate
```

Install dependencies:

```bash
pip install azure-ai-textanalytics requests
```

Deactivate:

```bash
deactivate
```

---

# Run Demo Script

```bash
chmod +x scripts/ai_services_demo.sh
./scripts/ai_services_demo.sh
```
