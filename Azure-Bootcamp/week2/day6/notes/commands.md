# Week 2 Day 6 - Security & RBAC Commands

## Resource Variables

```bash
RG="rg-azure-devops-day4"
AKS_NAME="aks-day4"
LOCATION="centralindia"
KV_NAME="kv-vibhav-day6"
```

---

# Exercise 6.1 - Explore Built-in RBAC Roles

Check current account:

```bash
az account show --query user
az ad signed-in-user show --query "{name:displayName,email:userPrincipalName}"
```

Get Resource Group scope:

```bash
az group show \
  --name $RG \
  --query id \
  -o tsv
```

Inspect built-in roles:

```bash
az role definition list --name Reader -o table
az role definition list --name Contributor -o table
```

---

# Exercise 6.2 - Service Principals and Role Assignments

Create Service Principals:

```bash
az ad sp create-for-rbac \
  --name sp-reader-day6 \
  --skip-assignment

az ad sp create-for-rbac \
  --name sp-contributor-day6 \
  --skip-assignment
```

Get Resource Group scope:

```bash
RG_SCOPE=$(az group show \
  --name $RG \
  --query id \
  -o tsv)
```

Assign Reader role:

```bash
az role assignment create \
  --assignee <READER_APP_ID> \
  --role Reader \
  --scope $RG_SCOPE
```

Assign Contributor role:

```bash
az role assignment create \
  --assignee <CONTRIBUTOR_APP_ID> \
  --role Contributor \
  --scope $RG_SCOPE
```

Verify assignments:

```bash
az role assignment list \
  --assignee <READER_APP_ID> \
  --all \
  -o table

az role assignment list \
  --assignee <CONTRIBUTOR_APP_ID> \
  --all \
  -o table
```

---

# Exercise 6.3 - Azure Key Vault

Register provider:

```bash
az provider register \
  --namespace Microsoft.KeyVault
```

Check registration:

```bash
az provider show \
  --namespace Microsoft.KeyVault \
  --query registrationState \
  -o tsv
```

Create Key Vault:

```bash
az keyvault create \
  --name $KV_NAME \
  --resource-group $RG \
  --location $LOCATION
```

View Key Vault:

```bash
az keyvault show \
  --name $KV_NAME \
  -o table
```

---

# Grant Yourself Key Vault Administrator

```bash
MY_OBJECT_ID=$(az ad signed-in-user show --query id -o tsv)

KV_ID=$(az keyvault show \
  --name $KV_NAME \
  --query id \
  -o tsv)

az role assignment create \
  --assignee-object-id $MY_OBJECT_ID \
  --assignee-principal-type User \
  --role "Key Vault Administrator" \
  --scope $KV_ID
```

---

# Store Secret

```bash
az keyvault secret set \
  --vault-name $KV_NAME \
  --name db-password \
  --value "SuperSecretPassword123!"
```

List secrets:

```bash
az keyvault secret list \
  --vault-name $KV_NAME \
  -o table
```

Read secret:

```bash
az keyvault secret show \
  --vault-name $KV_NAME \
  --name db-password \
  --query value \
  -o tsv
```

---

# Exercise 6.4 - Key Vault Integration with AKS

Enable addon:

```bash
az aks enable-addons \
  --addons azure-keyvault-secrets-provider \
  --resource-group $RG \
  --name $AKS_NAME
```

Check addon:

```bash
az aks show \
  --resource-group $RG \
  --name $AKS_NAME \
  --query addonProfiles.azureKeyvaultSecretsProvider
```

Retrieve identity:

```bash
CLIENT_ID=$(az aks show \
  -g $RG \
  -n $AKS_NAME \
  --query addonProfiles.azureKeyvaultSecretsProvider.identity.clientId \
  -o tsv)

OBJECT_ID=$(az aks show \
  -g $RG \
  -n $AKS_NAME \
  --query addonProfiles.azureKeyvaultSecretsProvider.identity.objectId \
  -o tsv)
```

Assign Key Vault access:

```bash
az role assignment create \
  --assignee-object-id $OBJECT_ID \
  --assignee-principal-type ServicePrincipal \
  --role "Key Vault Secrets User" \
  --scope $KV_ID
```

Get cluster credentials:

```bash
az aks get-credentials \
  --resource-group $RG \
  --name $AKS_NAME \
  --overwrite-existing
```

Verify CSI Driver:

```bash
kubectl get pods -n kube-system | grep secrets
```

Apply manifests:

```bash
kubectl apply -f manifests/secret-provider-class.yaml
kubectl apply -f manifests/test-pod.yaml
```

Verify secret mount:

```bash
kubectl exec -it busybox-secrets-store -- sh

ls /mnt/secrets-store
cat /mnt/secrets-store/db-password
```

---

# Exercise 6.5 - Microsoft Defender for Containers

Register provider:

```bash
az provider register \
  --namespace Microsoft.Security
```

Check pricing:

```bash
az security pricing show \
  --name Containers
```
