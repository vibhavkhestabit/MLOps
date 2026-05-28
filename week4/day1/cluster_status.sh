#!/bin/bash

# cluster_status.sh
# Quick Kubernetes cluster health check

set -euo pipefail

echo "========================================"
echo " KUBERNETES CLUSTER STATUS"
echo " $(date)"
echo "========================================"
echo ""

# --------------------------------------------------
# Check Cluster Connectivity
# --------------------------------------------------

if ! kubectl cluster-info &>/dev/null; then
    echo "❌ Cannot connect to Kubernetes cluster!"
    echo ""
    echo "Try:"
    echo "minikube start"
    exit 1
fi

echo "✓ Cluster is reachable"
echo ""

# --------------------------------------------------
# Node Status
# --------------------------------------------------

echo "=== NODES ==="

kubectl get nodes -o custom-columns=\
NAME:.metadata.name,\
STATUS:.status.conditions[-1].type,\
VERSION:.status.nodeInfo.kubeletVersion,\
OS:.status.nodeInfo.osImage

echo ""

# --------------------------------------------------
# Resource Usage
# --------------------------------------------------

echo "=== NODE RESOURCES ==="

kubectl top nodes 2>/dev/null || \
echo "Metrics not available (enable metrics-server)"

echo ""

# --------------------------------------------------
# Pod Summary
# --------------------------------------------------

echo "=== POD SUMMARY ==="

TOTAL=$(kubectl get pods -A --no-headers 2>/dev/null | wc -l)

RUNNING=$(kubectl get pods -A --no-headers 2>/dev/null | grep -c "Running" || true)

PENDING=$(kubectl get pods -A --no-headers 2>/dev/null | grep -c "Pending" || true)

FAILED=$(kubectl get pods -A --no-headers 2>/dev/null | grep -cE "Error|CrashLoop|Failed" || true)

echo "Total Pods : ${TOTAL}"
echo "Running    : ${RUNNING}"
echo "Pending    : ${PENDING}"
echo "Failed     : ${FAILED}"

echo ""

# --------------------------------------------------
# Recent Warnings
# --------------------------------------------------

echo "=== RECENT WARNINGS ==="

kubectl get events -A \
--field-selector type=Warning \
--sort-by='.lastTimestamp' 2>/dev/null | tail -5 || \
echo "No warnings found"

echo ""

# --------------------------------------------------
# Minikube Status
# --------------------------------------------------

if command -v minikube &>/dev/null; then
    echo "=== MINIKUBE STATUS ==="
    minikube status
fi

echo ""
echo "========================================"
echo " Cluster health check completed"
echo "========================================"