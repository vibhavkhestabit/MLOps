#!/bin/bash

set -e

RESOURCE_GROUP="week3-ai-rg"
WORKSPACE_NAME="week3-ml-workspace"
ENDPOINT_NAME="vibhav-iris-endpoint-01"
DEPLOYMENT_NAME="blue"

echo "========================================="
echo "Azure ML Model Deployment Automation"
echo "========================================="

echo ""
echo "1. Checking endpoint..."

if az ml online-endpoint show \
    --name $ENDPOINT_NAME \
    --workspace-name $WORKSPACE_NAME \
    --resource-group $RESOURCE_GROUP \
    >/dev/null 2>&1
then
    echo "✓ Endpoint already exists."
else
    echo "Creating endpoint..."

    az ml online-endpoint create \
      --file scripts/endpoint.yml \
      --workspace-name $WORKSPACE_NAME \
      --resource-group $RESOURCE_GROUP

    echo "✓ Endpoint created."
fi

echo ""
echo "2. Checking deployment..."

if az ml online-deployment show \
    --name $DEPLOYMENT_NAME \
    --endpoint-name $ENDPOINT_NAME \
    --workspace-name $WORKSPACE_NAME \
    --resource-group $RESOURCE_GROUP \
    >/dev/null 2>&1
then
    echo "✓ Deployment already exists."
else
    echo "Creating deployment..."

    az ml online-deployment create \
      --file scripts/deployment.yml \
      --all-traffic \
      --workspace-name $WORKSPACE_NAME \
      --resource-group $RESOURCE_GROUP

    echo "✓ Deployment created."
fi

echo ""
echo "3. Running smoke test..."

az ml online-endpoint invoke \
  --name $ENDPOINT_NAME \
  --request-file sample-request.json \
  --workspace-name $WORKSPACE_NAME \
  --resource-group $RESOURCE_GROUP

echo ""
echo "✓ Smoke test successful."

echo ""
echo "Scoring URI:"

az ml online-endpoint show \
  --name $ENDPOINT_NAME \
  --workspace-name $WORKSPACE_NAME \
  --resource-group $RESOURCE_GROUP \
  --query scoring_uri \
  -o tsv

echo ""
echo "========================================="
echo "Deployment automation completed."
echo "========================================="