#!/bin/bash

# install_k8s_local.sh
# Kubernetes Local Setup Script

set -euo pipefail

echo "============================================"
echo " Kubernetes Local Environment Setup"
echo "============================================"
echo ""

# ------------------------------------------------
# Check Docker
# ------------------------------------------------

echo "[1/5] Checking Docker..."

if ! docker info &>/dev/null; then
    echo "❌ Docker is not running."
    exit 1
fi

echo "✓ Docker is running"

# ------------------------------------------------
# Install kubectl
# ------------------------------------------------

echo ""
echo "[2/5] Installing kubectl..."

if command -v kubectl &>/dev/null; then
    echo "✓ kubectl already installed"
    kubectl version --client
else
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

    chmod +x kubectl

    sudo mv kubectl /usr/local/bin/

    echo "✓ kubectl installed successfully"
fi

# ------------------------------------------------
# Install Minikube
# ------------------------------------------------

echo ""
echo "[3/5] Installing Minikube..."

if command -v minikube &>/dev/null; then
    echo "✓ Minikube already installed"
    minikube version
else
    curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64

    sudo install minikube-linux-amd64 /usr/local/bin/minikube

    rm minikube-linux-amd64

    echo "✓ Minikube installed successfully"
fi

# ------------------------------------------------
# Start Cluster
# ------------------------------------------------

echo ""
echo "[4/5] Starting Minikube cluster..."
echo "This may take a few minutes..."

minikube start \
    --driver=docker \
    --cpus=2 \
    --memory=2048 \
    --disk-size=10g

# ------------------------------------------------
# Verify Cluster
# ------------------------------------------------

echo ""
echo "[5/5] Verifying cluster..."

kubectl cluster-info

echo ""
kubectl get nodes

echo ""
echo "============================================"
echo " Kubernetes Cluster Ready!"
echo "============================================"

echo ""
echo "Useful Commands:"
echo "kubectl get nodes"
echo "kubectl get pods -A"
echo "minikube dashboard"
echo "minikube stop"
echo "minikube delete"