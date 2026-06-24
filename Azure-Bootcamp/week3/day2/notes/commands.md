# Week 3 Day 2
# Commands Reference

---

# Verify Subscription

```bash
az account show
```

```bash
az account list --output table
```

---

# Install Azure ML Extension

```bash
az extension add --name ml
```

Verify:

```bash
az extension list
```

---

# Create Azure ML Workspace

```bash
az ml workspace create \
  --name week3-ml-workspace \
  --resource-group week3-ai-rg \
  --location eastus
```

---

# List Workspaces

```bash
az ml workspace list --output table
```

---

# Show Workspace

```bash
az ml workspace show \
  --name week3-ml-workspace \
  --resource-group week3-ai-rg
```

---

# Create Compute Instance

```bash
az ml compute create \
  --name day2practice \
  --resource-group week3-ai-rg \
  --workspace-name week3-ml-workspace \
  --type ComputeInstance \
  --size Standard_DS11_v2
```

---

# List Computes

```bash
az ml compute list \
  --resource-group week3-ai-rg \
  --workspace-name week3-ml-workspace \
  --output table
```

---

# Start Compute

```bash
az ml compute start \
  --name day2practice \
  --resource-group week3-ai-rg \
  --workspace-name week3-ml-workspace
```

---

# Stop Compute

```bash
az ml compute stop \
  --name day2practice \
  --resource-group week3-ai-rg \
  --workspace-name week3-ml-workspace
```

---

# Delete Compute

```bash
az ml compute delete \
  --name day2practice \
  --resource-group week3-ai-rg \
  --workspace-name week3-ml-workspace \
  --yes
```

---

# Create Dataset

```bash
az ml data create \
  --name iris-dataset \
  --resource-group week3-ai-rg \
  --workspace-name week3-ml-workspace \
  --type uri_file \
  --path ./data/iris.csv
```

---

# List Datasets

```bash
az ml data list \
  --resource-group week3-ai-rg \
  --workspace-name week3-ml-workspace \
  --output table
```

---

# Submit Training Job

```bash
az ml job create \
  --file job.yml \
  --resource-group week3-ai-rg \
  --workspace-name week3-ml-workspace
```

---

# Stream Job Logs

```bash
az ml job stream \
  --name <job-name> \
  --resource-group week3-ai-rg \
  --workspace-name week3-ml-workspace
```

---

# Show Job Details

```bash
az ml job show \
  --name <job-name> \
  --resource-group week3-ai-rg \
  --workspace-name week3-ml-workspace
```

---

# List Jobs

```bash
az ml job list \
  --resource-group week3-ai-rg \
  --workspace-name week3-ml-workspace \
  --output table
```

---

# Delete Resource Group (Cleanup)

```bash
az group delete \
  --name week3-ai-rg \
  --yes \
  --no-wait
```

---

# Local Python Environment

Create virtual environment:

```bash
python3 -m venv .venv
```

Activate:

```bash
source .venv/bin/activate
```

Install packages:

```bash
pip install azure-ai-textanalytics requests
```

Deactivate:

```bash
deactivate
```