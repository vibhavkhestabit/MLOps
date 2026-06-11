# Day 5 - Azure Container Registry (ACR)

## Exercise 5.1 - Create Azure Container Registry

```bash
az provider show \
  --namespace Microsoft.ContainerRegistry \
  --query registrationState \
  --output tsv

az acr create \
  --resource-group devops-lab-rg \
  --name vibhavacr001 \
  --sku Basic

az acr list \
  --resource-group devops-lab-rg \
  --output table

az acr show \
  --name vibhavacr001 \
  --query "{LoginServer:loginServer,SKU:sku.name}" \
  --output table
```

---

## Exercise 5.2 - Build Custom Docker Image

```bash
cd ~/MLOps-Training/Azure-Bootcamp/week1/day5/app

touch index.html
touch Dockerfile

docker build -t mywebapp:v1 .

docker images | grep mywebapp
```

---

## Exercise 5.3 - Login to ACR and Push Image

```bash
az acr login --name vibhavacr001

docker tag \
  mywebapp:v1 \
  vibhavacr001.azurecr.io/mywebapp:v1

docker push \
  vibhavacr001.azurecr.io/mywebapp:v1

az acr repository list \
  --name vibhavacr001 \
  --output table

az acr repository show-tags \
  --name vibhavacr001 \
  --repository mywebapp \
  --output table
```

---

## Exercise 5.4 - Deploy Image from ACR to ACI

### Enable Admin Access

```bash
az acr update \
  --name vibhavacr001 \
  --admin-enabled true
```

### Get Registry Credentials

```bash
ACR_USERNAME=$(az acr credential show \
  --name vibhavacr001 \
  --query username \
  --output tsv)

ACR_PASSWORD=$(az acr credential show \
  --name vibhavacr001 \
  --query passwords[0].value \
  --output tsv)
```

### Deploy Container

```bash
az container create \
  --resource-group devops-lab-rg \
  --name mywebapp-aci \
  --image vibhavacr001.azurecr.io/mywebapp:v1 \
  --registry-login-server vibhavacr001.azurecr.io \
  --registry-username $ACR_USERNAME \
  --registry-password $ACR_PASSWORD \
  --os-type Linux \
  --cpu 1 \
  --memory 1 \
  --dns-name-label mywebapp-vibhav-aci \
  --ports 80
```

### Verify Deployment

```bash
az container show \
  --resource-group devops-lab-rg \
  --name mywebapp-aci \
  --query "{State:instanceView.state,IP:ipAddress.ip,FQDN:ipAddress.fqdn}" \
  --output table
```

---

## Exercise 5.5 - Deployment Automation Script

```bash
mkdir -p scripts

touch scripts/acr_deploy.sh

chmod +x scripts/acr_deploy.sh

./acr_deploy.sh
```

---

## Exercise 5.6 - ACR Repository Inspection

```bash
az acr task list \
  --registry vibhavacr001 \
  --output table

az acr repository show \
  --name vibhavacr001 \
  --repository mywebapp
```

---

## Cleanup (Deferred Until Day 6 Completion)

```bash
az container delete \
  --resource-group devops-lab-rg \
  --name mywebapp-aci \
  --yes

az container list \
  --resource-group devops-lab-rg \
  --output table
```
