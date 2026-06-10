# Day 3 - Commands Reference

## Exercise 3.1 - Create Storage Account

```bash
STORAGE_ACCOUNT=vkstorage$(date +%s)
```

```bash
az storage account create \
  --name $STORAGE_ACCOUNT \
  --resource-group devops-lab-rg \
  --location centralindia \
  --sku Standard_LRS \
  --kind StorageV2
```

Verify:

```bash
az storage account list \
  --resource-group devops-lab-rg \
  -o table
```

---

## Retrieve Storage Account Key

```bash
az storage account keys list \
  --resource-group devops-lab-rg \
  --account-name $STORAGE_ACCOUNT \
  -o table
```

---

## Exercise 3.2 - Create Container

```bash
az storage container create \
  --name training-container \
  --account-name $STORAGE_ACCOUNT \
  --account-key <ACCOUNT_KEY>
```

---

## Create Sample File

```bash
echo "Azure Storage Day 3 Lab" > sample.txt
```

---

## Upload Blob

```bash
az storage blob upload \
  --account-name $STORAGE_ACCOUNT \
  --account-key <ACCOUNT_KEY> \
  --container-name training-container \
  --name sample.txt \
  --file sample.txt
```

---

## List Blobs

```bash
az storage blob list \
  --account-name $STORAGE_ACCOUNT \
  --account-key <ACCOUNT_KEY> \
  --container-name training-container \
  -o table
```

---

## Exercise 3.3 - Generate SAS URL

Generate SAS Token:

```bash
EXPIRY=$(date -u -d "1 day" '+%Y-%m-%dT%H:%MZ')
```

```bash
az storage blob generate-sas \
  --account-name $STORAGE_ACCOUNT \
  --account-key <ACCOUNT_KEY> \
  --container-name training-container \
  --name sample.txt \
  --permissions r \
  --expiry $EXPIRY \
  -o tsv
```

Construct URL:

```bash
https://<storage-account>.blob.core.windows.net/training-container/sample.txt?<sas-token>
```

---

## Exercise 3.4 - Create Azure File Share

```bash
az storage share-rm create \
  --resource-group devops-lab-rg \
  --storage-account $STORAGE_ACCOUNT \
  --name training-share
```

Verify:

```bash
az storage share-rm list \
  --resource-group devops-lab-rg \
  --storage-account $STORAGE_ACCOUNT \
  -o table
```

---

## Start VM

```bash
az vm start \
  --resource-group devops-lab-rg \
  --name devops-vm
```

---

## SSH into VM

```bash
ssh azureuser@<PUBLIC_IP>
```

---

## Install CIFS Utilities

```bash
sudo apt update
```

```bash
sudo apt install cifs-utils -y
```

---

## Create Mount Directory

```bash
sudo mkdir /azurefiles
```

---

## Mount Azure File Share

```bash
sudo mount -t cifs //<storage-account>.file.core.windows.net/training-share \
/azurefiles \
-o vers=3.0,username=<storage-account>,password=<ACCOUNT_KEY>,dir_mode=0777,file_mode=0777,serverino
```

---

## Verify Mount

```bash
df -h
```

```bash
mount | grep cifs
```

---

## Create Test File

```bash
echo "Azure File Share Works" | sudo tee /azurefiles/test.txt
```

---

## Exercise 3.5 - Automation Script

Make Executable:

```bash
chmod +x storage_ops.sh
```

Run:

```bash
./storage_ops.sh
```

---

## Exercise 3.6 - Storage Tiers

View Tier:

```bash
az storage account show \
  --name $STORAGE_ACCOUNT \
  --resource-group devops-lab-rg \
  --query accessTier
```

---

## Change Blob Tier

```bash
az storage blob set-tier \
  --account-name $STORAGE_ACCOUNT \
  --account-key <ACCOUNT_KEY> \
  --container-name training-container \
  --name sample.txt \
  --tier Cool
```

---

## Verify Tier

```bash
az storage blob show \
  --account-name $STORAGE_ACCOUNT \
  --account-key <ACCOUNT_KEY> \
  --container-name training-container \
  --name sample.txt \
  --query properties.accessTier
```

---

## VM Cost Optimization

Stop VM:

```bash
az vm stop \
  --resource-group devops-lab-rg \
  --name devops-vm
```

Deallocate VM:

```bash
az vm deallocate \
  --resource-group devops-lab-rg \
  --name devops-vm
```

Verify:

```bash
az vm get-instance-view \
  --resource-group devops-lab-rg \
  --name devops-vm \
  --query "instanceView.statuses[1].displayStatus"
```
