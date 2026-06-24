#!/bin/bash

set -e

# ==========================================
# Azure ML Workspace Setup Script
# Week 3 - Day 2
# ==========================================

RG="week3-ai-rg"
LOCATION="eastus"
WORKSPACE="week3-ml-workspace"
COMPUTE="day2practice"
DATASET_NAME="iris-dataset"
DATA_FILE="../data/iris.csv"

echo "======================================"
echo "Azure ML Workspace Setup"
echo "======================================"

echo ""
echo "Resource Group      : $RG"
echo "Location            : $LOCATION"
echo "Workspace           : $WORKSPACE"
echo "Compute Instance    : $COMPUTE"
echo "Dataset             : $DATASET_NAME"
echo ""

# ------------------------------------------
# Create Azure ML Workspace
# ------------------------------------------

echo "Creating Azure ML Workspace..."

az ml workspace create \
  --name $WORKSPACE \
  --resource-group $RG \
  --location $LOCATION

echo "Workspace ready."
echo ""

# ------------------------------------------
# Create Compute Instance
# ------------------------------------------

echo "Creating Compute Instance..."

az ml compute create \
  --name $COMPUTE \
  --resource-group $RG \
  --workspace-name $WORKSPACE \
  --type ComputeInstance \
  --size Standard_DS11_v2

echo "Compute Instance created."
echo ""

# ------------------------------------------
# Register Dataset
# ------------------------------------------

echo "Registering iris dataset..."

az ml data create \
  --name $DATASET_NAME \
  --resource-group $RG \
  --workspace-name $WORKSPACE \
  --type uri_file \
  --path $DATA_FILE

echo "Dataset registered."
echo ""

echo "======================================"
echo "Azure ML Environment Ready!"
echo "======================================"

echo "Next Steps:"
echo "1. Open Azure ML Studio"
echo "2. Verify Compute Instance"
echo "3. Verify Data Asset"
echo "4. Submit training job using job.yml"
echo "5. Monitor experiment runs"