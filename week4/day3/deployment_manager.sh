#!/bin/bash

set -e

echo "================================="
echo " DEPLOYMENT MANAGER"
echo "================================="

echo ""
echo "=== Deployments ==="
kubectl get deployments

echo ""
echo "=== ReplicaSets ==="
kubectl get rs

echo ""
echo "=== Pods ==="
kubectl get pods

echo ""
echo "=== Rollout Status ==="

for DEPLOYMENT in $(kubectl get deployment -o jsonpath='{.items[*].metadata.name}')
do
    echo ""
    echo "Deployment: $DEPLOYMENT"

    kubectl rollout status deployment/$DEPLOYMENT
done

echo ""
echo "=== Rollout History ==="

for DEPLOYMENT in $(kubectl get deployment -o jsonpath='{.items[*].metadata.name}')
do
    echo ""
    echo "Deployment: $DEPLOYMENT"

    kubectl rollout history deployment/$DEPLOYMENT
done

echo ""
echo "================================="
echo " Deployment Check Complete"
echo "================================="