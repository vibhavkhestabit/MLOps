# Day 4 Commands

## Create Resource Group

```bash
az group create \
  --name rg-azure-devops-day4 \
  --location centralindia
```

---

## Create Azure Container Registry

```bash
az acr create \
  --resource-group rg-azure-devops-day4 \
  --name vibhavacrday4 \
  --sku Basic
```

---

## Create AKS Cluster

```bash
az aks create \
  --resource-group rg-azure-devops-day4 \
  --name aks-day4 \
  --node-count 1 \
  --node-vm-size Standard_B2pls_v2 \
  --tier free \
  --generate-ssh-keys
```

---

## Connect kubectl to AKS

```bash
az aks get-credentials \
  --resource-group rg-azure-devops-day4 \
  --name aks-day4 \
  --overwrite-existing
```

---

## Verify Cluster

```bash
kubectl get nodes -o wide
```

---

## Check Node Architecture

```bash
kubectl get node \
-o jsonpath='{.items[0].status.nodeInfo.architecture}'
```

---

## Attach ACR to AKS

```bash
az aks update \
  --resource-group rg-azure-devops-day4 \
  --name aks-day4 \
  --attach-acr vibhavacrday4
```

---

## Login to ACR

```bash
az acr login --name vibhavacrday4
```

---

## Create Buildx Builder

```bash
docker buildx create \
  --name multiarch-builder \
  --use
```

---

## Build Multi-Architecture Image

```bash
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t vibhavacrday4.azurecr.io/flask-app:latest \
  --push .
```

---

## Verify Manifest Architectures

```bash
docker manifest inspect \
vibhavacrday4.azurecr.io/flask-app:latest
```

---

## Deploy Application

```bash
kubectl apply -f manifests/deployment.yaml
```

---

## Verify Pods

```bash
kubectl get pods
```

---

## Verify Deployment

```bash
kubectl get deployment
```

---

## Describe Deployment

```bash
kubectl describe deployment flask-app
```

---

## Check Services

```bash
kubectl get svc
```

---

## Verify Application

```bash
curl http://<external-ip>
```

---

## Verify ACR Images

```bash
az acr repository show-tags \
  --name vibhavacrday4 \
  --repository flask-app
```

---

## Push Changes to Azure DevOps

```bash
git add .
git commit -m "Day 4 CI/CD Pipeline"
git push azure main
```
