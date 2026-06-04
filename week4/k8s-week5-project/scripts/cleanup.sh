#!/bin/bash

set -e

echo "======================================="
echo "Cleaning Kubernetes Final Project"
echo "======================================="

kubectl delete -f manifests/ingress.yaml --ignore-not-found=true

kubectl delete -f manifests/assets-service.yaml --ignore-not-found=true
kubectl delete -f manifests/assets-deployment.yaml --ignore-not-found=true

kubectl delete -f manifests/backend-service.yaml --ignore-not-found=true
kubectl delete -f manifests/backend-deployment.yaml --ignore-not-found=true

kubectl delete -f manifests/frontend-service.yaml --ignore-not-found=true
kubectl delete -f manifests/frontend-deployment.yaml --ignore-not-found=true

echo ""
echo "Cleanup Complete"