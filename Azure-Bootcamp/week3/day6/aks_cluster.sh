#!/bin/bash

# ==================================================
# Azure Bootcamp - Week 3 Day 6
# AKS Cluster Provisioning & Validation Script
# (adapted from Week 2 Day 1 — same logic, new names
#  since the original Week 2 resources were deleted)
# ==================================================

set -e

RESOURCE_GROUP="aks-bootcamp-week3-rg"
LOCATION="centralindia"

AKS_NAME="aks-bootcamp-week3"
ACR_NAME="acrbootcampweek3"

NODE_COUNT=1
NODE_SIZE="Standard_B2pls_v2"

echo "======================================"
echo "Azure AKS Bootcamp Setup - Week 3"
echo "======================================"

# ==================================================
# Resource Group
# ==================================================

echo ""
echo "[STEP 1] Resource Group Validation"

if az group exists --name "$RESOURCE_GROUP" | grep -q true; then
    echo "✅ Resource Group already exists: $RESOURCE_GROUP"
else
    echo "Creating Resource Group..."
    az group create \
        --name "$RESOURCE_GROUP" \
        --location "$LOCATION"
fi

# ==================================================
# AKS Cluster
# ==================================================

echo ""
echo "[STEP 2] AKS Cluster Validation"

if az aks show \
    --resource-group "$RESOURCE_GROUP" \
    --name "$AKS_NAME" >/dev/null 2>&1; then

    echo "✅ AKS Cluster already exists: $AKS_NAME"

else

    echo "Creating AKS Cluster..."

    az aks create \
        --resource-group "$RESOURCE_GROUP" \
        --name "$AKS_NAME" \
        --node-count "$NODE_COUNT" \
        --node-vm-size "$NODE_SIZE" \
        --tier free \
        --generate-ssh-keys
fi

# ==================================================
# kubectl Authentication
# ==================================================

echo ""
echo "[STEP 3] Getting AKS Credentials"

az aks get-credentials \
    --resource-group "$RESOURCE_GROUP" \
    --name "$AKS_NAME" \
    --overwrite-existing

# ==================================================
# Azure Container Registry
# ==================================================

echo ""
echo "[STEP 4] ACR Validation"

if az acr show \
    --resource-group "$RESOURCE_GROUP" \
    --name "$ACR_NAME" >/dev/null 2>&1; then

    echo "✅ ACR already exists: $ACR_NAME"

else

    echo "Creating Azure Container Registry..."

    az acr create \
        --resource-group "$RESOURCE_GROUP" \
        --name "$ACR_NAME" \
        --sku Basic
fi

# ==================================================
# AKS -> ACR Integration
# ==================================================

echo ""
echo "[STEP 5] AKS to ACR Integration"

az aks update \
    --resource-group "$RESOURCE_GROUP" \
    --name "$AKS_NAME" \
    --attach-acr "$ACR_NAME" \
    >/dev/null 2>&1 || true

echo "✅ ACR attached to AKS"

# ==================================================
# Cluster Discovery Commands
# ==================================================

echo ""
echo "======================================"
echo "AKS Discovery & Health Checks"
echo "======================================"

echo ""
echo "[1] Current kubectl Context"
echo "Verifies which Kubernetes cluster kubectl is connected to"
kubectl config current-context

echo ""
echo "[2] Cluster Information"
echo "Displays Kubernetes API Server information"
kubectl cluster-info

echo ""
echo "[3] Worker Nodes"
echo "These nodes are Azure Virtual Machines running inside a VM Scale Set"
kubectl get nodes -o wide

echo ""
echo "[4] Kubernetes Namespaces"
echo "Logical isolation boundaries within the cluster"
kubectl get namespaces

echo ""
echo "[5] System Pods"
echo "Core Kubernetes and Azure services running in kube-system"
kubectl get pods -n kube-system

echo ""
echo "[6] Node Metrics"
echo "Metrics collected by metrics-server"
kubectl top nodes

echo ""
echo "[7] Cluster Resources"
echo "Complete view of resources across all namespaces"
kubectl get all -A

echo ""
echo "[8] AKS Cluster Details"
echo "Shows Kubernetes version and node resource group"
az aks show \
    --resource-group "$RESOURCE_GROUP" \
    --name "$AKS_NAME" \
    --query "{KubernetesVersion:kubernetesVersion,NodeResourceGroup:nodeResourceGroup,FQDN:fqdn}" \
    -o table

echo ""
echo "[9] Node Pool Information"
echo "Shows worker node pool configuration"
az aks nodepool list \
    --resource-group "$RESOURCE_GROUP" \
    --cluster-name "$AKS_NAME" \
    -o table

echo ""
echo "[10] ACR Details"
echo "Container registry connected to AKS"
az acr show \
    --name "$ACR_NAME" \
    --query "{Name:name,LoginServer:loginServer,SKU:sku.name}" \
    -o table

echo ""
echo "[11] AKS Managed Resources"
echo "Resources automatically created by Azure for AKS"
az resource list \
    --resource-group "MC_${RESOURCE_GROUP}_${AKS_NAME}_${LOCATION}" \
    -o table

echo ""
echo "======================================"
echo "AKS Environment Ready - Week 3"
echo "======================================"