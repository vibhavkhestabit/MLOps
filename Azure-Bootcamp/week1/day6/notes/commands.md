# Day 6 - Week 1 Mini Project Commands

## Build Docker Image

```bash
docker build -t week1-project:v1 .
```

---

## Verify Image

```bash
docker images | grep week1-project
```

---

## Get ACR Login Server

```bash
az acr show \
  --name vibhavacr001 \
  --query loginServer \
  --output tsv
```

---

## Tag Image

```bash
docker tag \
  week1-project:v1 \
  vibhavacr001.azurecr.io/week1-project:v1
```

---

## Login to ACR

```bash
az acr login --name vibhavacr001
```

---

## Push Image

```bash
docker push \
vibhavacr001.azurecr.io/week1-project:v1
```

---

## Verify Repository

```bash
az acr repository list \
  --name vibhavacr001 \
  --output table
```

---

## Verify Tags

```bash
az acr repository show-tags \
  --name vibhavacr001 \
  --repository week1-project \
  --output table
```

---

## Get Storage Key

```bash
STORAGE_KEY=$(az storage account keys list \
  --resource-group devops-lab-rg \
  --account-name vkstorage1781011715 \
  --query "[0].value" \
  --output tsv)
```

---

## Get ACR Credentials

```bash
ACR_USERNAME=$(az acr credential show \
  --name vibhavacr001 \
  --query username \
  --output tsv)
```

```bash
ACR_PASSWORD=$(az acr credential show \
  --name vibhavacr001 \
  --query passwords[0].value \
  --output tsv)
```

---

## Deploy Container to ACI

```bash
az container create \
  --resource-group devops-lab-rg \
  --name week1-project-aci \
  --image vibhavacr001.azurecr.io/week1-project:v1 \
  --registry-login-server vibhavacr001.azurecr.io \
  --registry-username $ACR_USERNAME \
  --registry-password $ACR_PASSWORD \
  --os-type Linux \
  --cpu 1 \
  --memory 1 \
  --ports 80 \
  --dns-name-label week1-vibhav-project \
  --azure-file-volume-account-name vkstorage1781011715 \
  --azure-file-volume-account-key "$STORAGE_KEY" \
  --azure-file-volume-share-name training-share \
  --azure-file-volume-mount-path /mnt/azurefiles
```

---

## Check Deployment Status

```bash
az container show \
  --resource-group devops-lab-rg \
  --name week1-project-aci \
  --query "{State:instanceView.state,IP:ipAddress.ip,FQDN:ipAddress.fqdn}" \
  --output table
```

---

## Test Application

```bash
curl http://week1-vibhav-project.centralindia.azurecontainer.io
```

---

## View Container Logs

```bash
az container logs \
  --resource-group devops-lab-rg \
  --name week1-project-aci
```

---

## Run Full Automation

```bash
chmod +x week1_project.sh
```

```bash
./week1_project.sh
```
