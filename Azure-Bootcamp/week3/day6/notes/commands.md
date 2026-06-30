# commands.md

# Week 3 – Day 6

# AI Log Analyser — AKS + ACR + Key Vault + CI/CD

---

# 1. Local app development and testing

```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

```bash
# Run with no config — confirms /healthz works, /readyz and /analyse/*
# correctly return 503 instead of crashing
uvicorn main:app --reload --port 8005
```

```bash
curl -s http://localhost:8005/healthz
curl -s -w "\nHTTP %{http_code}\n" http://localhost:8005/readyz
curl -s -w "\nHTTP %{http_code}\n" -X POST http://localhost:8005/analyse/text \
  -H "Content-Type: application/json" -d '{"log_text": "   "}'
curl -s -w "\nHTTP %{http_code}\n" -X POST http://localhost:8005/analyse/text \
  -H "Content-Type: application/json" -d '{"log_text": "ERROR something broke"}'
```

```bash
# Test with fake-but-present credentials — confirms /readyz flips to 200
# and /analyse/text reaches a real network call (502 connection error,
# not a crash) before any real Azure OpenAI resource existed
export AZURE_OPENAI_ENDPOINT="https://fake-resource.openai.azure.com/"
export AZURE_OPENAI_API_KEY="fake-key-for-testing"
export AZURE_OPENAI_DEPLOYMENT="fake-gpt4o"
uvicorn main:app --reload --port 8005
```

---

# 2. AKS + ACR provisioning (Week 3 resources)

Resources from Week 2 were deleted after that week finished, so these
were recreated fresh for Week 3 under new names.

```bash
chmod +x aks_cluster.sh
./aks_cluster.sh
```

Creates (idempotent — safe to rerun):
- Resource group: `aks-bootcamp-week3-rg` (centralindia)
- AKS cluster: `aks-bootcamp-week3` (1 node, `Standard_B2pls_v2`, free tier)
- ACR: `acrbootcampweek3` (Basic SKU)
- Attaches ACR to AKS

```bash
# Verify
az acr show --name acrbootcampweek3 --query loginServer -o tsv
az aks show --resource-group aks-bootcamp-week3-rg --name aks-bootcamp-week3 \
  --query provisioningState -o tsv
kubectl get nodes -o wide
```

---

# 3. Git / Azure DevOps repo setup

```bash
cd ~/MLOps-Training
git status
git add Azure-Bootcamp/week3/day6/
git commit -m "Add Week 3 Day 6 capstone: FastAPI app, Dockerfile, manifests, pipeline"
```

```bash
# Personal Access Token created in Azure DevOps (Code: Read & Write)
# used as the password when prompted
git push azure main
```

```bash
# Verify what actually made it to the remote
git ls-files | grep "week3/day6"
git log --oneline -5
git show HEAD --stat
```

---

# 4. Azure DevOps service connections

Created via Project Settings → Service connections (UI, no CLI):

- `acr-connection-week3` — Docker Registry → Azure Container Registry →
  `acrbootcampweek3`
- `aks-connection-week3` — Kubernetes Service Connection → Azure
  Subscription → cluster `aks-bootcamp-week3` →
  **"Use cluster admin credentials"** checked (needed because the
  default flow failed with a `401 Unauthorized` trying to create a role
  binding on the cluster)

---

# 5. Pipeline creation and debugging

Created via Pipelines → New Pipeline → Azure Repos Git → Existing Azure
Pipelines YAML file → path `Azure-Bootcamp/week3/day6/azure_pipeline.yml`.

Bugs hit and fixed across several runs:

```bash
# Bug 1: Dockerfile COPY app/... -> "/app": not found
# Fix: removed app/ prefix, since source files sit flat in day6/, not
# inside an app/ subfolder. Edited Dockerfile, then:
git add Azure-Bootcamp/week3/day6/Dockerfile
git commit -m "Fix Dockerfile COPY paths - flat structure, no app/ subfolder"
git push azure main
```

```bash
# Bug 2 (typo while manually fixing locally): "Copy analyser.py ."
# instead of "COPY analyser.py ." - Dockerfile instruction case typo.
# Fixed directly in the file before the next push.
```

```bash
# Bug 3: Deploy stage failed with:
#   error: the path "Azure-Bootcamp/week3/day6/manifests/" does not exist
# Root cause: Azure DevOps "deployment:" jobs do NOT auto-checkout the
# repo (unlike regular "job:" jobs). Fix: added "checkout: self" as the
# first step under deploy: steps: in azure_pipeline.yml.
git add Azure-Bootcamp/week3/day6/azure_pipeline.yml
git commit -m "Fix deploy job: add checkout self (deployment jobs don't auto-checkout)"
git push azure main
```

```bash
# First fully green run - verify the live deployment
kubectl get pods
kubectl get deployment ai-log-analyser
kubectl get service ai-log-analyser-service
curl http://<external-ip>/healthz
curl -w "\nHTTP %{http_code}\n" http://<external-ip>/readyz
curl -X POST http://<external-ip>/analyse/text \
  -H "Content-Type: application/json" -d '{"log_text": "ERROR test"}'
# (at this point: 503, correctly "not configured yet" - no Key Vault
# wiring existed yet)
```

---

# 6. gpt-5-mini compatibility fixes (after Day 5 credentials existed)

```bash
# Bug 4: gpt-5-mini rejects `temperature` and `max_tokens` (400 error) -
# GPT-5-family reasoning models require max_completion_tokens instead,
# and reject temperature entirely. Fixed in analyser.py.

# Bug 5: empty response from gpt-5-mini even with no API error - the
# token budget (800) was fully consumed by hidden reasoning tokens
# before any visible output was written. Fixed by raising
# max_completion_tokens to 2000, and adding finish_reason / usage
# detail to the error message for future diagnosis.
```

```bash
# Local verification with real credentials (key was rotated after
# accidentally being pasted in chat during testing)
export AZURE_OPENAI_ENDPOINT="https://vibha-mqyv8dko-eastus2.cognitiveservices.azure.com/"
export AZURE_OPENAI_API_KEY="<rotated key>"
export AZURE_OPENAI_DEPLOYMENT="gpt-5-mini"
export AZURE_OPENAI_API_VERSION="2025-04-01-preview"

uvicorn main:app --reload --port 8005
```

```bash
curl -s -w "\nHTTP %{http_code}\n" -X POST http://localhost:8005/analyse/text \
  -H "Content-Type: application/json" \
  -d '{"log_text": "2026-06-29 10:14:02 ERROR [db-pool] Connection refused: could not connect to postgres on port 5432. Retrying... 2026-06-29 10:14:05 ERROR [db-pool] Max retries exceeded, giving up."}'
# -> HTTP 200, real structured root-cause summary
```

---

# 7. Azure Key Vault setup

```bash
az keyvault create \
  --name kv-bootcamp-week3 \
  --resource-group aks-bootcamp-week3-rg \
  --location centralindia
```

```bash
# Bug 6: az keyvault secret set -> (Forbidden) ForbiddenByRbac
# Vault was created with enableRbacAuthorization: true - being the
# creator does not automatically grant secret access. Fix: explicit
# role assignment for own user account.
az role assignment create \
  --role "Key Vault Secrets Officer" \
  --assignee "<your-azure-ad-email>" \
  --scope "/subscriptions/<sub-id>/resourceGroups/aks-bootcamp-week3-rg/providers/Microsoft.KeyVault/vaults/kv-bootcamp-week3"
```

```bash
# Store the three secrets (using the rotated key)
az keyvault secret set --vault-name kv-bootcamp-week3 \
  --name "azure-openai-endpoint" \
  --value "https://vibha-mqyv8dko-eastus2.cognitiveservices.azure.com/"

az keyvault secret set --vault-name kv-bootcamp-week3 \
  --name "azure-openai-api-key" \
  --value "<rotated key>"

az keyvault secret set --vault-name kv-bootcamp-week3 \
  --name "azure-openai-deployment" \
  --value "gpt-5-mini"
```

```bash
# Verify
az keyvault secret list --vault-name kv-bootcamp-week3 --query "[].name" -o table
```

---

# 8. Secrets Store CSI driver wiring

```bash
# Enable the AKS add-on (not on by default)
az aks enable-addons \
  --addons azure-keyvault-secrets-provider \
  --name aks-bootcamp-week3 \
  --resource-group aks-bootcamp-week3-rg
```

```bash
# Get the auto-created managed identity's clientId
az aks show \
  --name aks-bootcamp-week3 \
  --resource-group aks-bootcamp-week3-rg \
  --query "addonProfiles.azureKeyvaultSecretsProvider.identity" \
  -o json
```

```bash
# Grant that identity read access to the vault's secrets
az role assignment create \
  --role "Key Vault Secrets User" \
  --assignee "<clientId-from-above>" \
  --scope "/subscriptions/<sub-id>/resourceGroups/aks-bootcamp-week3-rg/providers/Microsoft.KeyVault/vaults/kv-bootcamp-week3"
```

```bash
# manifests/secret-provider-class.yaml created (adapted from Week 2 Day
# 6's secret-provider-class.yaml), pointing at the new identity and
# vault, fetching all three secrets, with a secretObjects block to sync
# them into a real Kubernetes Secret (azure-openai-secrets) so they can
# be consumed as plain env vars.

# manifests/deployment.yaml updated: added env vars sourced from
# azure-openai-secrets via secretKeyRef, added the CSI volume mount,
# and flipped the readinessProbe from /healthz to /readyz (liveness
# stays on /healthz deliberately - see README).

git add Azure-Bootcamp/week3/day6/manifests/deployment.yaml \
        Azure-Bootcamp/week3/day6/manifests/secret-provider-class.yaml
git commit -m "Wire Key Vault secrets via CSI driver, flip readiness probe to /readyz"
git push azure main
```

---

# 9. Final end-to-end verification (live, real credentials, real model)

```bash
kubectl describe pod <pod-name>
# confirms: env vars sourced from secret 'azure-openai-secrets',
# Optional: false on all three, pod Ready: True, Restart Count: 0

kubectl get nodes
kubectl get deployment
kubectl get pods
kubectl get service ai-log-analyser-service
```

```bash
curl -w "\nHTTP %{http_code}\n" http://<external-ip>/readyz
# -> 200 {"status":"ready"}

curl -X POST http://<external-ip>/analyse/text \
  -H "Content-Type: application/json" \
  -d '{"log_text": "2026-06-29 10:14:02 ERROR [db-pool] Connection refused: could not connect to postgres on port 5432. Retrying... 2026-06-29 10:14:05 ERROR [db-pool] Max retries exceeded, giving up."}'
# -> HTTP 200, real structured root-cause summary from gpt-5-mini,
# served live from AKS over the public internet
```

```bash
# Browser-based test UI (FastAPI's auto-generated Swagger docs,
# zero extra code needed):
#   http://<external-ip>/docs
```

---

# 10. Cleanup (optional, when done with the project)

```bash
# Tear down everything created for Week 3 in one shot
az group delete \
  --name aks-bootcamp-week3-rg \
  --yes \
  --no-wait
```

Note: this deletes the resource group containing AKS, ACR, and Key
Vault together (Key Vault has soft-delete enabled with a 90-day
retention by default, so it will not be immediately purged unless
`az keyvault purge` is run separately).