#!/bin/bash

# ====================================================
# AKS Monitoring Setup
# Week 2 Day 5
# ====================================================

RESOURCE_GROUP="rg-azure-devops-day4"
AKS_CLUSTER="aks-day4"
WORKSPACE_NAME="law-aks-day5"

echo "Creating Log Analytics Workspace..."

az monitor log-analytics workspace create \
  --resource-group $RESOURCE_GROUP \
  --workspace-name $WORKSPACE_NAME \
  --location centralindia

echo "Fetching Workspace ID..."

WORKSPACE_ID=$(az monitor log-analytics workspace show \
  --resource-group $RESOURCE_GROUP \
  --workspace-name $WORKSPACE_NAME \
  --query id \
  -o tsv)

echo "Registering Microsoft.Insights..."

az provider register --namespace Microsoft.Insights

echo "Enabling AKS Monitoring Addon..."

az aks enable-addons \
  --resource-group $RESOURCE_GROUP \
  --name $AKS_CLUSTER \
  --addons monitoring \
  --workspace-resource-id $WORKSPACE_ID

echo "Verifying Monitoring Pods..."

kubectl get pods -n kube-system | grep ama

echo "Monitoring setup complete."