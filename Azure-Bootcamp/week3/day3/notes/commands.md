# Week 3 - Day 3 Commands

---

# Verify Dataset

```bash
az ml data list \
  --workspace-name week3-ml-workspace \
  --resource-group week3-ai-rg \
  -o table
```

---

# Verify Compute Cluster

```bash
az ml compute list \
  --workspace-name week3-ml-workspace \
  --resource-group week3-ai-rg \
  -o table
```

---

# Submit AutoML Job

```bash
az ml job create \
  --file scripts/automl_job.yml \
  --workspace-name week3-ml-workspace \
  --resource-group week3-ai-rg
```

---

# Stream Job Logs

```bash
az ml job stream \
  --name <job-name> \
  --workspace-name week3-ml-workspace \
  --resource-group week3-ai-rg
```

---

# Check Job Status

```bash
az ml job show \
  --name <job-name> \
  --workspace-name week3-ml-workspace \
  --resource-group week3-ai-rg
```

---

# List Child Jobs

```bash
az ml job list \
  --parent-job-name <job-name> \
  --workspace-name week3-ml-workspace \
  --resource-group week3-ai-rg \
  -o table
```

---

# List Registered Models

```bash
az ml model list \
  --workspace-name week3-ml-workspace \
  --resource-group week3-ai-rg \
  -o table
```

---

# View Model Details

```bash
az ml model show \
  --name iris-knn-model \
  --version 1 \
  --workspace-name week3-ml-workspace \
  --resource-group week3-ai-rg
```

---

# Create Online Endpoint

```bash
az ml online-endpoint create \
  --file scripts/endpoint.yml \
  --workspace-name week3-ml-workspace \
  --resource-group week3-ai-rg
```

---

# Create Deployment

```bash
az ml online-deployment create \
  --file scripts/deployment.yml \
  --all-traffic \
  --workspace-name week3-ml-workspace \
  --resource-group week3-ai-rg
```

---

# Get Endpoint Credentials

```bash
az ml online-endpoint get-credentials \
  --name vibhav-iris-endpoint-01 \
  --workspace-name week3-ml-workspace \
  --resource-group week3-ai-rg
```

---

# Get Scoring URI

```bash
az ml online-endpoint show \
  --name vibhav-iris-endpoint-01 \
  --workspace-name week3-ml-workspace \
  --resource-group week3-ai-rg \
  --query scoring_uri \
  -o tsv
```

---

# Invoke Endpoint

```bash
curl -X POST \
  <SCORING_URI> \
  -H "Authorization: Bearer <PRIMARY_KEY>" \
  -H "Content-Type: application/json" \
  -d @sample-request.json
```

---

# Run Deployment Automation

```bash
chmod +x scripts/model_deploy.sh
./scripts/model_deploy.sh
```

---

# Delete Endpoint

```bash
az ml online-endpoint delete \
  --name vibhav-iris-endpoint-01 \
  --workspace-name week3-ml-workspace \
  --resource-group week3-ai-rg \
  --yes
```

---

# Delete Compute Cluster

```bash
az ml compute delete \
  --name cpu-cluster \
  --workspace-name week3-ml-workspace \
  --resource-group week3-ai-rg \
  --yes
```

---

# Verify Cleanup

```bash
az ml online-endpoint list \
  --workspace-name week3-ml-workspace \
  --resource-group week3-ai-rg \
  -o table
```

```bash
az ml compute list \
  --workspace-name week3-ml-workspace \
  --resource-group week3-ai-rg \
  -o table
```
