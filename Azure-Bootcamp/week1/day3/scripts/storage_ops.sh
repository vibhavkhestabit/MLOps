#!/bin/bash

# ==========================================
# Azure Storage Operations Script
# Day 3 - Azure Storage
# ==========================================

RESOURCE_GROUP="devops-lab-rg"
STORAGE_ACCOUNT="vkstorage1781011715"
CONTAINER_NAME="training-container"

echo "========================================="
echo "AZURE STORAGE OPERATIONS"
echo "========================================="

echo ""
echo "1. Creating sample file..."

echo "Hello from Azure Storage Day 3" > sample.txt

echo ""
echo "2. Retrieving Storage Account Key..."

ACCOUNT_KEY=$(az storage account keys list \
  --resource-group $RESOURCE_GROUP \
  --account-name $STORAGE_ACCOUNT \
  --query "[0].value" \
  -o tsv)

echo "Key Retrieved"

echo ""
echo "3. Uploading Blob..."

az storage blob upload \
  --account-name $STORAGE_ACCOUNT \
  --account-key "$ACCOUNT_KEY" \
  --container-name $CONTAINER_NAME \
  --name sample.txt \
  --file sample.txt \
  --overwrite

echo ""
echo "4. Listing Blobs..."

az storage blob list \
  --account-name $STORAGE_ACCOUNT \
  --account-key "$ACCOUNT_KEY" \
  --container-name $CONTAINER_NAME \
  -o table

echo ""
echo "5. Generating SAS URL..."

EXPIRY=$(date -u -d "1 day" '+%Y-%m-%dT%H:%MZ')

SAS=$(az storage blob generate-sas \
  --account-name $STORAGE_ACCOUNT \
  --account-key "$ACCOUNT_KEY" \
  --container-name $CONTAINER_NAME \
  --name sample.txt \
  --permissions r \
  --expiry $EXPIRY \
  -o tsv)

URL="https://${STORAGE_ACCOUNT}.blob.core.windows.net/${CONTAINER_NAME}/sample.txt?$SAS"

echo ""
echo "SAS URL:"
echo "$URL"

echo ""
echo "6. Cleanup Local File..."

rm sample.txt

echo ""
echo "Completed Successfully"
echo "========================================="