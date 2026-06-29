# commands.md

# Week 3 – Day 5

# Azure OpenAI Service

---

# Create Azure OpenAI Resource

```bash
az cognitiveservices account create \
  --name week3-openai \
  --resource-group week3-ai-rg \
  --kind OpenAI \
  --sku S0 \
  --location eastus \
  --yes
```

---

# List Cognitive Services Accounts

```bash
az cognitiveservices account list \
  --query "[].{Name:name,Kind:kind,Location:location}" \
  --output table
```

---

# List Available Account Kinds

```bash
az cognitiveservices account list-kinds \
  --output table
```

---

# List Supported Locations

```bash
az provider show \
  --namespace Microsoft.CognitiveServices \
  --query "resourceTypes[?resourceType=='accounts'].locations[]" \
  --output table
```

---

# List Available OpenAI SKUs

```bash
az cognitiveservices account list-skus \
  --kind OpenAI \
  --location eastus \
  --output table
```

---

# Show Azure OpenAI Resource

```bash
az cognitiveservices account show \
  --name week3-openai \
  --resource-group week3-ai-rg \
  --output table
```

---

# Retrieve API Keys

```bash
az cognitiveservices account keys list \
  --name week3-openai \
  --resource-group week3-ai-rg
```

---

# Retrieve Endpoint

```bash
az cognitiveservices account show \
  --name week3-openai \
  --resource-group week3-ai-rg \
  --query properties.endpoint \
  --output tsv
```

---

# List Model Deployments

```bash
az cognitiveservices account deployment list \
  --name Vibha-mqyv8dko-eastus2 \
  --resource-group week3-ai-rg \
  --output table
```

---

# Create Python Environment

```bash
python -m venv .venv
source .venv/bin/activate
```

---

# Install Dependencies

```bash
pip install -r requirements.txt
```

---

# Load Environment Variables

```bash
source scripts/set_env.sh
```

---

# Verify Environment Variables

```bash
env | grep AZURE_OPENAI
```

---

# Test Chat Completion using cURL

```bash
./scripts/chat_completion_curl.sh
```

---

# Test Chat Completion using Python

```bash
python scripts/chat_completion.py
```

---

# DevOps Assistant Persona

```bash
python scripts/devops_assistant.py
python scripts/devops_assistant_2.py
```

---

# Generate Embeddings

```bash
python scripts/embeddings_demo.py
```

---

# Measure Cosine Similarity

```bash
python scripts/cosine_similarity.py
```

---

# Build Q&A App

```bash
python scripts/readme_qa.py
```

---

# Build Vector Store

```bash
python scripts/build_chunks.py
python scripts/build_embeddings.py
```

---

# Run RAG Application

```bash
python scripts/rag_qa.py
```

---

# Delete Entire Resource Group (Optional Cleanup)

```bash
az group delete \
  --name week3-ai-rg \
  --yes \
  --no-wait
```
