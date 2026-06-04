#!/bin/bash

set -e

echo "======================================="
echo "Deploying Kubernetes Final Project"
echo "======================================="

kubectl apply -f manifests/frontend-deployment.yaml
kubectl apply -f manifests/frontend-service.yaml

kubectl apply -f manifests/backend-deployment.yaml
kubectl apply -f manifests/backend-service.yaml

kubectl apply -f manifests/assets-deployment.yaml
kubectl apply -f manifests/assets-service.yaml

kubectl apply -f manifests/ingress.yaml

echo ""
echo "Waiting for deployments..."

kubectl rollout status deployment/frontend
kubectl rollout status deployment/backend
kubectl rollout status deployment/assets

echo ""
echo "Deployment Complete"
echo ""

kubectl get deploy
kubectl get svc
kubectl get ingress