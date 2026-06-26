# Commands Reference - Week 3 Day 4

## Activate Environment

```bash
source .venv/bin/activate
source scripts/set_env.sh
```

---

# Install Dependencies

```bash
pip install azure-ai-vision-imageanalysis
pip install azure-ai-textanalytics
pip install azure-ai-formrecognizer
pip install azure-cognitiveservices-speech
pip install requests
```

---

# Verify Installed Packages

```bash
pip list | grep azure
```

---

# OCR

```bash
python scripts/ocr.py data/printed.png
python scripts/ocr.py data/handwritten.jpg
```

---

# Key Phrase Extraction

```bash
python scripts/key_phrase_extraction.py
```

---

# Named Entity Recognition

```bash
python scripts/named_entities.py
```

---

# Sentiment Analysis

```bash
python scripts/sentiment_analysis.py
```

---

# Document Intelligence

```bash
python scripts/document_intelligence.py
```

---

# Speech Service

```bash
python scripts/speech_to_text.py
```

---

# OCR Pipeline

```bash
python scripts/ocr_pipeline.py data/printed.png
python scripts/ocr_pipeline.py data/handwritten.jpg
```

---

# Docker Build

```bash
docker build -t azure-ocr-app .
```

---

# Docker Run

```bash
docker run \
-e AI_ENDPOINT=$AI_ENDPOINT \
-e AI_KEY=$AI_KEY \
azure-ocr-app
```

---

# Verify Azure Resources

```bash
az resource list \
--resource-group week3-ai-rg \
--output table
```

---

# View AI Service Endpoint

```bash
az cognitiveservices account show \
--name week3-ai-services \
--resource-group week3-ai-rg \
--query properties.endpoint \
--output tsv
```

---

# View AI Service Keys

```bash
az cognitiveservices account keys list \
--name week3-ai-services \
--resource-group week3-ai-rg
```

---

# View Speech Service Keys

```bash
az cognitiveservices account keys list \
--name week3-speech-service \
--resource-group week3-ai-rg
```
