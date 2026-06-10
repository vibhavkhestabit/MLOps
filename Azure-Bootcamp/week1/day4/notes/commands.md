# Day 4 - Azure Container Instances (ACI)

## commands.md

---

# Exercise 4.1 - Deploy a Public Container

## Register Azure Container Instance Provider

```bash
az provider register --namespace Microsoft.ContainerInstance
```

## Verify Registration

```bash
az provider show \
  --namespace Microsoft.ContainerInstance \
  --query registrationState \
  --output tsv
```

## Deploy Nginx Container to ACI

```bash
az container create \
  --resource-group devops-lab-rg \
  --name nginx-aci \
  --image nginx \
  --os-type Linux \
  --cpu 1 \
  --memory 1 \
  --dns-name-label nginx-vibhav-aci \
  --ports 80
```

---

# Exercise 4.2 - Inspect Container and Stream Logs

## Check Container Status

```bash
az container show \
  --resource-group devops-lab-rg \
  --name nginx-aci \
  --query "{State:instanceView.state,IP:ipAddress.ip,FQDN:ipAddress.fqdn}" \
  --output table
```

## Get Public IP

```bash
az container show \
  --resource-group devops-lab-rg \
  --name nginx-aci \
  --query ipAddress.ip \
  --output tsv
```

## View Container Logs

```bash
az container logs \
  --resource-group devops-lab-rg \
  --name nginx-aci
```

## Test Application

```bash
curl http://98.70.217.104
```

---

# Exercise 4.3 - Environment Variables

## Create Environment Variable Demo Container

```bash
az container create \
  --resource-group devops-lab-rg \
  --name env-demo \
  --image alpine \
  --os-type Linux \
  --cpu 1 \
  --memory 1 \
  --restart-policy Never \
  --environment-variables APP_ENV=training STUDENT=Vibhav \
  --command-line "env"
```

## Check Container State

```bash
az container show \
  --resource-group devops-lab-rg \
  --name env-demo \
  --query instanceView.state \
  --output tsv
```

## View Environment Variables

```bash
az container logs \
  --resource-group devops-lab-rg \
  --name env-demo
```

---

# Exercise 4.4 - Mount Azure Files Volume

## List Available File Shares

```bash
az storage share-rm list \
  --resource-group devops-lab-rg \
  --storage-account vkstorage1781011715 \
  --output table
```

## Get Storage Account Key

```bash
az storage account keys list \
  --resource-group devops-lab-rg \
  --account-name vkstorage1781011715 \
  --output table
```

## Store Key in Variable

```bash
STORAGE_KEY="<storage-account-key>"
```

## Create Container with Azure Files Mount

```bash
az container create \
  --resource-group devops-lab-rg \
  --name file-share-demo \
  --image alpine \
  --os-type Linux \
  --cpu 1 \
  --memory 1 \
  --restart-policy Never \
  --command-line "sh -c 'echo Azure Files Mounted > /mnt/share/test.txt && cat /mnt/share/test.txt'" \
  --azure-file-volume-account-name vkstorage1781011715 \
  --azure-file-volume-account-key $STORAGE_KEY \
  --azure-file-volume-share-name training-share \
  --azure-file-volume-mount-path /mnt/share
```

## View Container Logs

```bash
az container logs \
  --resource-group devops-lab-rg \
  --name file-share-demo
```

## Verify File Created in Azure Files

```bash
az storage file list \
  --share-name training-share \
  --account-name vkstorage1781011715 \
  --account-key "$STORAGE_KEY" \
  --output table
```

---

# Useful ACI Management Commands

## List Container Groups

```bash
az container list \
  --resource-group devops-lab-rg \
  --output table
```

## Show Container Details

```bash
az container show \
  --resource-group devops-lab-rg \
  --name nginx-aci
```

## Restart Container

```bash
az container restart \
  --resource-group devops-lab-rg \
  --name nginx-aci
```

## Stop Container

```bash
az container stop \
  --resource-group devops-lab-rg \
  --name nginx-aci
```

## Start Container

```bash
az container start \
  --resource-group devops-lab-rg \
  --name nginx-aci
```

---

# Cleanup

## Delete Nginx Container

```bash
az container delete \
  --resource-group devops-lab-rg \
  --name nginx-aci \
  --yes
```

## Delete Environment Variable Demo

```bash
az container delete \
  --resource-group devops-lab-rg \
  --name env-demo \
  --yes
```

## Delete Azure Files Demo Container

```bash
az container delete \
  --resource-group devops-lab-rg \
  --name file-share-demo \
  --yes
```

## Verify Cleanup

```bash
az container list \
  --resource-group devops-lab-rg \
  --output table
```
