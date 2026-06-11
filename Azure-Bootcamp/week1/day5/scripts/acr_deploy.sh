#!/bin/bash

set -e

RESOURCE_GROUP="devops-lab-rg"
ACR_NAME="vibhavacr001"
IMAGE_NAME="mywebapp"
IMAGE_TAG="v1"
ACI_NAME="mywebapp-aci"

echo "================================="
echo "Azure ACR Deployment Script"
echo "================================="

echo "Logging into ACR..."
az acr login --name $ACR_NAME

echo "Building image..."
docker build -t ${IMAGE_NAME}:${IMAGE_TAG} ../app

echo "Tagging image..."
docker tag \
${IMAGE_NAME}:${IMAGE_TAG} \
${ACR_NAME}.azurecr.io/${IMAGE_NAME}:${IMAGE_TAG}

echo "Pushing image..."
docker push \
${ACR_NAME}.azurecr.io/${IMAGE_NAME}:${IMAGE_TAG}

echo "Getting registry credentials..."

ACR_USERNAME=$(az acr credential show \
--name $ACR_NAME \
--query username \
-o tsv)

ACR_PASSWORD=$(az acr credential show \
--name $ACR_NAME \
--query passwords[0].value \
-o tsv)

echo "Removing existing container (if any)..."

az container delete \
--resource-group $RESOURCE_GROUP \
--name $ACI_NAME \
--yes || true

echo "Creating new ACI deployment..."

az container create \
--resource-group $RESOURCE_GROUP \
--name $ACI_NAME \
--image ${ACR_NAME}.azurecr.io/${IMAGE_NAME}:${IMAGE_TAG} \
--registry-login-server ${ACR_NAME}.azurecr.io \
--registry-username $ACR_USERNAME \
--registry-password $ACR_PASSWORD \
--os-type Linux \
--cpu 1 \
--memory 1 \
--ports 80 \
--dns-name-label mywebapp-vibhav-aci

echo "Deployment Complete"