# AI Log Analyser — Deployment Documentation

Complete guide for a new engineer to deploy this application from scratch.
Written from real experience — every bug and fix documented here actually happened.

---

## What this application does

A FastAPI web service that accepts server log text (raw JSON body or file upload)
and returns an AI-generated root-cause analysis using Azure OpenAI (gpt-5-mini).

Live endpoints once deployed:
- `GET  /healthz`         — liveness probe, always 200 if process is running
- `GET  /readyz`          — readiness probe, 200 only once all 3 OpenAI env vars are present
- `POST /analyse/text`    — JSON body `{"log_text": "..."}`
- `POST /analyse/upload`  — multipart file upload
- `GET  /docs`            — Swagger UI for browser-based testing, no extra code needed

---

## Prerequisites — what you need before starting

- Azure account with an active subscription
- Azure CLI installed and logged in: `az login`
- kubectl installed
- Docker with buildx support installed
- Python 3.10+ installed
- Git installed
- An Azure DevOps organisation and project created
- An Azure OpenAI resource created with a gpt-5-mini (or compatible) model deployed

---

## Repository structure

```
Azure-Bootcamp/week3/day6/
├── main.py                          FastAPI routes and endpoint definitions
├── analyser.py                      Azure OpenAI client logic (only file that knows about the model)
├── requirements.txt                 Pinned Python dependencies
├── .env.example                     Template for local environment variables
├── Dockerfile                       Container build instructions
├── aks_cluster.sh                   Idempotent AKS + ACR provisioning script
├── azure_pipeline.yml               Azure DevOps CI/CD pipeline definition
├── manifests/
│   ├── deployment.yaml              Kubernetes Deployment spec
│   ├── service.yaml                 Kubernetes LoadBalancer Service
│   └── secret-provider-class.yaml  CSI driver config to sync Key Vault → K8s Secret
└── README.md                        Project overview and design decisions
```

---

## Step 1 — Run the app locally first (verify before touching Azure)

```bash
cd Azure-Bootcamp/week3/day6
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
```

Start with no config — proves the app boots and fails gracefully:

```bash
uvicorn main:app --reload --port 8005
```

Expected: server starts, no crash.

```bash
curl http://localhost:8005/healthz
# {"status":"ok"}

curl -w "\nHTTP %{http_code}\n" http://localhost:8005/readyz
# 503 — missing AZURE_OPENAI_* vars, correct behaviour

curl -X POST http://localhost:8005/analyse/text \
  -H "Content-Type: application/json" \
  -d '{"log_text": "ERROR something broke"}'
# 503 "not configured yet" — correct, no crash
```

Now test with real credentials:

```bash
export AZURE_OPENAI_ENDPOINT="https://<your-resource>.cognitiveservices.azure.com/"
export AZURE_OPENAI_API_KEY="<your-key>"
export AZURE_OPENAI_DEPLOYMENT="gpt-5-mini"
export AZURE_OPENAI_API_VERSION="2025-04-01-preview"

uvicorn main:app --reload --port 8005
```

```bash
curl -s -w "\nHTTP %{http_code}\n" -X POST http://localhost:8005/analyse/text \
  -H "Content-Type: application/json" \
  -d '{"log_text": "2026-06-29 ERROR [db-pool] Connection refused on port 5432"}'
# HTTP 200 with a real root-cause summary from gpt-5-mini
```

If you get HTTP 200 here, the app works. Proceed.

---

## Step 2 — Provision AKS and ACR

The provisioning script is idempotent — safe to run multiple times, will not
duplicate resources.

```bash
chmod +x aks_cluster.sh
./aks_cluster.sh
```

This creates:
- Resource group: `aks-bootcamp-week3-rg` in centralindia
- AKS cluster: `aks-bootcamp-week3` (1 node, Standard_B2pls_v2, free tier control plane)
- ACR: `acrbootcampweek3` (Basic SKU)
- Attaches ACR to AKS so pods can pull images without imagePullSecrets

Verify:

```bash
az acr show --name acrbootcampweek3 --query loginServer -o tsv
# acrbootcampweek3.azurecr.io

az aks show \
  --resource-group aks-bootcamp-week3-rg \
  --name aks-bootcamp-week3 \
  --query provisioningState -o tsv
# Succeeded

kubectl get nodes
# 1 node in Ready status
```

---

## Step 3 — Set up Azure Key Vault and store secrets

### Create the vault

```bash
az keyvault create \
  --name kv-bootcamp-week3 \
  --resource-group aks-bootcamp-week3-rg \
  --location centralindia
```

### IMPORTANT — grant yourself access before trying to write secrets

The vault is created with `enableRbacAuthorization: true`. Being the creator
grants zero implicit permissions. You must explicitly assign yourself a role
or every `az keyvault secret set` command will return ForbiddenByRbac.

```bash
az role assignment create \
  --role "Key Vault Secrets Officer" \
  --assignee "<your-azure-ad-email>" \
  --scope "/subscriptions/<sub-id>/resourceGroups/aks-bootcamp-week3-rg/providers/Microsoft.KeyVault/vaults/kv-bootcamp-week3"
```

Wait 30-60 seconds for the role assignment to propagate before continuing.

### Store the three secrets

```bash
az keyvault secret set \
  --vault-name kv-bootcamp-week3 \
  --name "azure-openai-endpoint" \
  --value "https://<your-resource>.cognitiveservices.azure.com/"

az keyvault secret set \
  --vault-name kv-bootcamp-week3 \
  --name "azure-openai-api-key" \
  --value "<your-api-key>"

az keyvault secret set \
  --vault-name kv-bootcamp-week3 \
  --name "azure-openai-deployment" \
  --value "gpt-5-mini"
```

Verify all three are stored:

```bash
az keyvault secret list --vault-name kv-bootcamp-week3 --query "[].name" -o table
# azure-openai-api-key
# azure-openai-deployment
# azure-openai-endpoint
```

---

## Step 4 — Enable the Secrets Store CSI driver on AKS

This add-on is not enabled by default. It allows pods to pull secrets from
Key Vault and have them injected as environment variables at pod startup.

```bash
az aks enable-addons \
  --addons azure-keyvault-secrets-provider \
  --name aks-bootcamp-week3 \
  --resource-group aks-bootcamp-week3-rg
```

### Get the managed identity the addon created

```bash
az aks show \
  --name aks-bootcamp-week3 \
  --resource-group aks-bootcamp-week3-rg \
  --query "addonProfiles.azureKeyvaultSecretsProvider.identity" \
  -o json
```

Note the `clientId` from the output. You need this in the next command.

### Grant the managed identity read access to your vault

```bash
az role assignment create \
  --role "Key Vault Secrets User" \
  --assignee "<clientId-from-above>" \
  --scope "/subscriptions/<sub-id>/resourceGroups/aks-bootcamp-week3-rg/providers/Microsoft.KeyVault/vaults/kv-bootcamp-week3"
```

### Update secret-provider-class.yaml with your values

Open `manifests/secret-provider-class.yaml` and replace:
- `userAssignedIdentityID` with the `clientId` from above
- `tenantId` with your Azure tenant ID (visible in `az account show`)
- `keyvaultName` is already set to `kv-bootcamp-week3`

---

## Step 5 — Set up Azure DevOps and the CI/CD pipeline

### Push code to Azure DevOps

In Azure DevOps, create a new Repo. Then from your local machine:

```bash
git remote add azure https://dev.azure.com/<org>/<project>/_git/<repo>
git add Azure-Bootcamp/week3/day6/
git commit -m "Add Week 3 Day 6 capstone"
git push azure main
# You will be prompted for username and a Personal Access Token (PAT)
# Create a PAT in Azure DevOps → User Settings → Personal Access Tokens
# Scope: Code → Read & Write
```

### Create two service connections

In Azure DevOps → Project Settings → Service connections → New service connection:

**Connection 1 — ACR:**
- Type: Docker Registry
- Registry type: Azure Container Registry
- Select subscription and registry: `acrbootcampweek3`
- Name: `acr-connection-week3`

**Connection 2 — AKS:**
- Type: Kubernetes Service Connection
- Authentication method: Azure Subscription
- Select cluster: `aks-bootcamp-week3`
- Namespace: default
- Check: "Use cluster admin credentials"  ← required, the default flow fails with 401
- Name: `aks-connection-week3`

### Create the pipeline

Pipelines → New Pipeline → Azure Repos Git → select your repo
→ Existing Azure Pipelines YAML file
→ Path: `Azure-Bootcamp/week3/day6/azure_pipeline.yml`
→ Run

---

## Step 6 — Verify the live deployment

After a green pipeline run:

```bash
kubectl get pods
# 2 pods Running, 1/1 Ready each

kubectl get service ai-log-analyser-service
# TYPE: LoadBalancer, EXTERNAL-IP: <ip>, PORT: 80

kubectl describe pod <pod-name>
# Environment section shows:
# AZURE_OPENAI_ENDPOINT: <set to the key 'AZURE_OPENAI_ENDPOINT' in secret 'azure-openai-secrets'>
# AZURE_OPENAI_API_KEY:  <set to the key 'AZURE_OPENAI_API_KEY'  in secret 'azure-openai-secrets'>
# AZURE_OPENAI_DEPLOYMENT: <set to the key 'AZURE_OPENAI_DEPLOYMENT' in secret 'azure-openai-secrets'>
# Optional: false on all three — if any secret failed to sync, the pod would not start
```

Hit the live app:

```bash
curl http://<external-ip>/healthz
# {"status":"ok"}

curl http://<external-ip>/readyz
# {"status":"ready"}

curl -X POST http://<external-ip>/analyse/text \
  -H "Content-Type: application/json" \
  -d '{"log_text": "ERROR connection refused to postgres on port 5432"}'
# HTTP 200 with real AI-generated root-cause analysis
```

Browser UI — open in any browser:
```
http://<external-ip>/docs
```

---

## Known bugs and fixes — read these before debugging

### Bug 1: `COPY app/... /app not found` during Docker build
The Dockerfile was adapted from a project that had source files in an `app/`
subfolder. This project's files sit flat in `day6/`. Remove `app/` prefix
from all COPY instructions:
```dockerfile
COPY requirements.txt .
COPY main.py .
COPY analyser.py .
```

### Bug 2: `the path "manifests/" does not exist` in deploy stage
Azure DevOps `deployment:` jobs do NOT auto-checkout the repo unlike regular
`job:` blocks. Add `checkout: self` as the first step under `deploy: steps:`.
```yaml
strategy:
  runOnce:
    deploy:
      steps:
      - checkout: self    # mandatory — without this, manifests/ does not exist on the agent
      - task: Kubernetes@1
```

### Bug 3: Kubernetes service connection 401 during setup
When creating the AKS service connection in Azure DevOps using "Azure
Subscription" auth, it tries to create a role binding on the cluster and
fails with 401. Fix: check "Use cluster admin credentials" instead.

### Bug 4: Key Vault `ForbiddenByRbac` on `az keyvault secret set`
The vault is created with RBAC authorization enabled. Being the creator does
not grant secret access automatically. Assign yourself `Key Vault Secrets
Officer` explicitly before writing any secrets (see Step 3 above).

### Bug 5: `gpt-5-mini` returns 400 Bad Request
gpt-5-mini is a reasoning model. It rejects:
- `temperature` parameter entirely
- `max_tokens` — use `max_completion_tokens` instead

See `analyser.py` — the call is already corrected.

### Bug 6: `gpt-5-mini` returns 200 but empty response
Reasoning models spend hidden tokens on internal reasoning before writing
visible output. If `max_completion_tokens` is too low, the budget is fully
consumed by reasoning and nothing is written. Set to minimum 2000.
The error message in `analyser.py` now includes `finish_reason` and
`reasoning_tokens` for diagnosis if this recurs.

### Bug 7: Wrong virtual environment activated
`pip install` succeeded but the wrong venv got it. After `cd`-ing between
project directories, always verify:
```bash
which python
# Should show: .../week3/day6/venv/...
```
If wrong: `deactivate` then `source venv/bin/activate` from the correct folder.

### Bug 8: `AZURE_OPENAI_KEY` vs `AZURE_OPENAI_API_KEY`
The app reads `AZURE_OPENAI_API_KEY`. If you export `AZURE_OPENAI_KEY`
(no `_API_`), the app sees it as unset and returns 503. Names are
case-sensitive and exact — check with `env | grep AZURE`.

---

## Design decisions — why things are the way they are

**Why two separate health endpoints (/healthz and /readyz)?**
Liveness failure causes Kubernetes to restart the pod. Readiness failure
only pauses traffic routing. A Key Vault outage or missing secret should
pause traffic, not restart a healthy process. Restarting pods during a
secret issue creates a crash loop that makes the problem worse.

**Why is analyser.py separate from main.py?**
analyser.py is the only file that knows anything about Azure OpenAI. If
the model changes, the SDK changes, or the provider changes, only analyser.py
needs to touch it. main.py handles routes and validation and never changes
for AI-related work.

**Why `kubectl apply` before `kubectl set image` in the pipeline?**
`kubectl set image` only works if the Deployment object already exists.
On a brand-new cluster, it doesn't. `apply -f manifests/` is idempotent —
it creates the Deployment on first run and harmlessly re-applies on every
run after. Running both together handles both first deploy and updates.

**Why LoadBalancer instead of Ingress?**
With a single service, Ingress adds complexity without value. Ingress earns
its place when multiple services need to share one public entry point using
path or hostname routing. This project has one service.

**Why build multi-arch images?**
Development machines (especially Apple Silicon) run ARM. Cloud nodes run
AMD64. Without `--platform linux/amd64,linux/arm64`, an image built locally
or on an ARM CI agent may fail to start on AMD64 nodes with an architecture
mismatch error.

---

## Cleanup — tear down everything when done

```bash
az group delete \
  --name aks-bootcamp-week3-rg \
  --yes \
  --no-wait
```

This deletes the resource group and everything in it: AKS, ACR, Key Vault,
load balancer, public IP. Key Vault has soft-delete enabled with 90-day
retention — it will not be immediately purged. To fully purge:

```bash
az keyvault purge --name kv-bootcamp-week3
```