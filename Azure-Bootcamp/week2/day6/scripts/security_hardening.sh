#!/bin/bash

set -e

RG="rg-azure-devops-day4"
AKS_NAME="aks-day4"
LOCATION="centralindia"
KV_NAME="kv-vibhav-day6"

echo "======================================="
echo " Azure Security Hardening Script"
echo "======================================="

#
# 1. Microsoft.KeyVault Registration
#
echo ""
echo "1. Checking Microsoft.KeyVault registration..."

STATE=$(az provider show \
    --namespace Microsoft.KeyVault \
    --query registrationState \
    -o tsv 2>/dev/null || echo "NotRegistered")

if [ "$STATE" = "Registered" ]; then
    echo "✅ Microsoft.KeyVault already registered."
else
    echo "⏳ Registering Microsoft.KeyVault..."
    az provider register --namespace Microsoft.KeyVault

    while true; do
        STATE=$(az provider show \
            --namespace Microsoft.KeyVault \
            --query registrationState \
            -o tsv)

        [ "$STATE" = "Registered" ] && break

        echo "Current State: $STATE"
        sleep 10
    done

    echo "✅ Microsoft.KeyVault registered."
fi

#
# 2. Key Vault
#
echo ""
echo "2. Checking Key Vault..."

if az keyvault show --name $KV_NAME &>/dev/null
then
    echo "✅ Key Vault already exists."
else
    echo "⏳ Creating Key Vault..."
    az keyvault create \
      --name $KV_NAME \
      --resource-group $RG \
      --location $LOCATION >/dev/null

    echo "✅ Key Vault created."
fi

#
# 3. Secret
#
echo ""
echo "3. Creating/updating secret..."

az keyvault secret set \
    --vault-name $KV_NAME \
    --name db-password \
    --value "SuperSecretPassword123!" >/dev/null

echo "✅ Secret available in Key Vault."

#
# 4. AKS Addon
#
echo ""
echo "4. Checking AKS Key Vault addon..."

ADDON_ENABLED=$(az aks show \
  -g $RG \
  -n $AKS_NAME \
  --query addonProfiles.azureKeyvaultSecretsProvider.enabled \
  -o tsv 2>/dev/null)

if [ "$ADDON_ENABLED" = "true" ]; then
    echo "✅ Azure Key Vault Secrets Provider already enabled."
else
    echo "⏳ Enabling addon..."

    az aks enable-addons \
      --addons azure-keyvault-secrets-provider \
      --resource-group $RG \
      --name $AKS_NAME

    echo "✅ Addon enabled."
fi

#
# 5. Managed Identity
#
echo ""
echo "5. Retrieving Managed Identity..."

OBJECT_ID=$(az aks show \
  -g $RG \
  -n $AKS_NAME \
  --query addonProfiles.azureKeyvaultSecretsProvider.identity.objectId \
  -o tsv)

echo "✅ Managed Identity Object ID:"
echo "$OBJECT_ID"

#
# 6. RBAC Assignment
#
echo ""
echo "6. Checking Key Vault Secrets User role..."

KV_ID=$(az keyvault show \
  --name $KV_NAME \
  --query id \
  -o tsv)

ROLE_EXISTS=$(az role assignment list \
  --assignee-object-id $OBJECT_ID \
  --scope $KV_ID \
  --query "[?roleDefinitionName=='Key Vault Secrets User'] | length(@)" \
  -o tsv)

if [ "$ROLE_EXISTS" -ge 1 ]; then
    echo "✅ Key Vault Secrets User role already assigned."
else
    echo "⏳ Assigning Key Vault Secrets User role..."

    az role assignment create \
      --assignee-object-id $OBJECT_ID \
      --assignee-principal-type ServicePrincipal \
      --role "Key Vault Secrets User" \
      --scope $KV_ID >/dev/null

    echo "✅ Role assigned."
fi

echo ""
echo "======================================="
echo " Security Hardening Completed"
echo "======================================="