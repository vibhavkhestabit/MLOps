#!/bin/bash

RESOURCE_GROUP="devops-lab-rg"
LOCATION="centralindia"

echo "=================================="
echo "Azure Environment Setup"
echo "=================================="

echo ""
echo "Checking Azure CLI..."

if ! command -v az &> /dev/null
then
    echo "Azure CLI not installed"
    exit 1
fi

echo "Azure CLI found"
echo ""

echo "Current Account:"
az account show --output table

echo ""
echo "Creating Resource Group..."

az group create \
  --name $RESOURCE_GROUP \
  --location $LOCATION \
  --output table

echo ""
echo "Listing Resource Groups..."

az group list --output table

echo ""
echo "Setup Completed Successfully"