#!/bin/bash

set -e

echo "======================================="
echo "Testing Kubernetes Final Project"
echo "======================================="

MINIKUBE_IP=$(minikube ip)

echo ""
echo "Frontend Test"
curl -s http://${MINIKUBE_IP}/

echo ""
echo ""
echo "Backend Test"
curl -s http://${MINIKUBE_IP}/api

echo ""
echo ""
echo "Assets Test"
curl -s http://${MINIKUBE_IP}/static

echo ""
echo ""
echo "Cluster Status"
kubectl get deploy
kubectl get pods
kubectl get svc
kubectl get ingress