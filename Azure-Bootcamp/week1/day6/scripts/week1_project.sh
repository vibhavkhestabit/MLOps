#!/bin/bash

set -e

echo "========================================="
echo "AZURE WEEK 1 MINI PROJECT"
echo "========================================="

# --------------------------------------------------
# Variables
# --------------------------------------------------

RESOURCE_GROUP="devops-lab-rg"

ACR_NAME="vibhavacr001"
STORAGE_ACCOUNT="vkstorage1781011715"
FILE_SHARE="training-share"

IMAGE_NAME="week1-project"
IMAGE_TAG="v1"

ACI_NAME="week1-project-aci"
DNS_LABEL="week1-vibhav-project"

# --------------------------------------------------
# Step 1 - Verify Existing Resources
# --------------------------------------------------

echo ""
echo "Checking Azure resources..."

az group show \
  --name $RESOURCE_GROUP \
  > /dev/null

echo "✓ Resource Group exists"

az acr show \
  --name $ACR_NAME \
  > /dev/null

echo "✓ ACR exists"

az storage account show \
  --name $STORAGE_ACCOUNT \
  --resource-group $RESOURCE_GROUP \
  > /dev/null

echo "✓ Storage Account exists"

# --------------------------------------------------
# Step 2 - Get ACR Login Server
# --------------------------------------------------

echo ""
echo "Getting ACR Login Server..."

ACR_LOGIN_SERVER=$(az acr show \
  --name $ACR_NAME \
  --query loginServer \
  --output tsv)

echo "ACR Login Server: $ACR_LOGIN_SERVER"

# --------------------------------------------------
# Step 3 - Build Image
# --------------------------------------------------

echo ""
echo "Building Docker Image..."

docker build \
  -t $IMAGE_NAME:$IMAGE_TAG \
  ../app

# --------------------------------------------------
# Step 4 - Tag Image
# --------------------------------------------------

echo ""
echo "Tagging Image..."

docker tag \
  $IMAGE_NAME:$IMAGE_TAG \
  $ACR_LOGIN_SERVER/$IMAGE_NAME:$IMAGE_TAG

# --------------------------------------------------
# Step 5 - Login to ACR
# --------------------------------------------------

echo ""
echo "Logging into ACR..."

az acr login --name $ACR_NAME

# --------------------------------------------------
# Step 6 - Push Image
# --------------------------------------------------

echo ""
echo "Pushing Image to ACR..."

docker push \
  $ACR_LOGIN_SERVER/$IMAGE_NAME:$IMAGE_TAG

# --------------------------------------------------
# Step 7 - Get Storage Key
# --------------------------------------------------

echo ""
echo "Getting Storage Key..."

STORAGE_KEY=$(az storage account keys list \
  --resource-group $RESOURCE_GROUP \
  --account-name $STORAGE_ACCOUNT \
  --query "[0].value" \
  --output tsv)

# --------------------------------------------------
# Step 8 - Get ACR Credentials
# --------------------------------------------------

echo ""
echo "Getting ACR Credentials..."

ACR_USERNAME=$(az acr credential show \
  --name $ACR_NAME \
  --query username \
  --output tsv)

ACR_PASSWORD=$(az acr credential show \
  --name $ACR_NAME \
  --query passwords[0].value \
  --output tsv)

# --------------------------------------------------
# Step 9 - Remove Existing Container
# --------------------------------------------------

echo ""
echo "Checking existing container..."

if az container show \
    --resource-group $RESOURCE_GROUP \
    --name $ACI_NAME \
    > /dev/null 2>&1
then

    echo "Existing container found."

    az container delete \
      --resource-group $RESOURCE_GROUP \
      --name $ACI_NAME \
      --yes

    echo "Waiting 30 seconds..."
    sleep 30

else

    echo "No existing container."

fi

# --------------------------------------------------
# Step 10 - Deploy ACI
# --------------------------------------------------

echo ""
echo "Deploying Azure Container Instance..."

az container create \
  --resource-group $RESOURCE_GROUP \
  --name $ACI_NAME \
  --image $ACR_LOGIN_SERVER/$IMAGE_NAME:$IMAGE_TAG \
  --registry-login-server $ACR_LOGIN_SERVER \
  --registry-username $ACR_USERNAME \
  --registry-password "$ACR_PASSWORD" \
  --os-type Linux \
  --cpu 1 \
  --memory 1 \
  --ports 80 \
  --dns-name-label $DNS_LABEL \
  --azure-file-volume-account-name $STORAGE_ACCOUNT \
  --azure-file-volume-account-key "$STORAGE_KEY" \
  --azure-file-volume-share-name $FILE_SHARE \
  --azure-file-volume-mount-path /mnt/azurefiles

# --------------------------------------------------
# Step 11 - Deployment Status
# --------------------------------------------------

echo ""
echo "Fetching Deployment Details..."

az container show \
  --resource-group $RESOURCE_GROUP \
  --name $ACI_NAME \
  --query "{State:instanceView.state,IP:ipAddress.ip,FQDN:ipAddress.fqdn}" \
  --output table

echo ""
echo "========================================="
echo "DEPLOYMENT SUCCESSFUL"
echo "========================================="

echo ""
echo "Application URL:"
echo "http://$DNS_LABEL.centralindia.azurecontainer.io"

echo ""
echo "Week 1 Azure Mini Project Completed"