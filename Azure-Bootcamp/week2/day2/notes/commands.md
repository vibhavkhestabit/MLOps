# Azure Bootcamp - Week 2 Day 2

# Commands Reference

## Verify AKS Environment

```bash
kubectl get nodes
```

```bash
kubectl get pods -n kube-system
```

```bash
az acr list -o table
```

---

# Exercise 2.1 - Deploy Application

## Create Deployment

```bash
kubectl apply -f manifests/nginx-deployment.yaml
```

## Verify Deployment

```bash
kubectl get deployments
```

## Verify ReplicaSet

```bash
kubectl get rs
```

## Verify Pods

```bash
kubectl get pods -o wide
```

## Inspect Pod

```bash
kubectl describe pod <pod-name>
```

---

# Exercise 2.2 - LoadBalancer Service

## Create Service

```bash
kubectl apply -f manifests/nginx-service.yaml
```

## Verify Service

```bash
kubectl get svc
```

## Describe Service

```bash
kubectl describe svc nginx-service
```

## View Endpoints

```bash
kubectl get endpoints nginx-service
```

## Test External Access

```bash
curl http://<external-ip>
```

## View Azure Public IPs

```bash
az network public-ip list -o table
```

---

# Exercise 2.3 - Install NGINX Ingress Controller

## Verify Helm

```bash
helm version
```

## Add Helm Repository

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
```

```bash
helm repo update
```

## Create Namespace

```bash
kubectl create namespace ingress-nginx
```

## Install Controller

```bash
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx
```

## Verify Controller Pods

```bash
kubectl get pods -n ingress-nginx
```

## Verify Controller Service

```bash
kubectl get svc -n ingress-nginx
```

---

# Exercise 2.4 - Configure Ingress

## Create Ingress

```bash
kubectl apply -f manifests/nginx-ingress.yaml
```

## Verify Ingress

```bash
kubectl get ingress
```

## Inspect Ingress

```bash
kubectl describe ingress nginx-ingress
```

## Test Ingress

```bash
curl http://<ingress-public-ip>
```

---

# Exercise 2.5 - Manual Scaling

## Scale Deployment

```bash
kubectl scale deployment nginx-deployment --replicas=3
```

## Verify Deployment

```bash
kubectl get deployment nginx-deployment
```

## Verify ReplicaSet

```bash
kubectl get rs
```

## Verify Pods

```bash
kubectl get pods -o wide
```

## Watch Pods Live

```bash
kubectl get pods -w
```

---

# Exercise 2.6 - Horizontal Pod Autoscaler (HPA)

## Update Deployment

```bash
kubectl apply -f manifests/nginx-deployment.yaml
```

## Verify Rollout

```bash
kubectl rollout status deployment/nginx-deployment
```

## Create HPA

```bash
kubectl autoscale deployment nginx-deployment \
  --cpu-percent=50 \
  --min=3 \
  --max=10
```

## Verify HPA

```bash
kubectl get hpa
```

## Inspect HPA

```bash
kubectl describe hpa nginx-deployment
```

## Verify Metrics

```bash
kubectl top nodes
```

```bash
kubectl top pods
```

---

# Generate Load

## Create Load Generator

```bash
kubectl run load-generator \
  --image=busybox \
  --restart=Never \
  -- /bin/sh -c "while true; do wget -q -O- http://nginx-service; done"
```

## Watch HPA

```bash
kubectl get hpa -w
```

## Watch Deployment

```bash
kubectl get deployment -w
```

## Remove Load Generator

```bash
kubectl delete pod load-generator
```

---

# Cleanup Workloads

## Delete HPA

```bash
kubectl delete hpa nginx-deployment
```

## Delete Ingress

```bash
kubectl delete -f manifests/nginx-ingress.yaml
```

## Remove Ingress Controller

```bash
helm uninstall ingress-nginx -n ingress-nginx
```

```bash
kubectl delete namespace ingress-nginx
```

## Delete Service

```bash
kubectl delete -f manifests/nginx-service.yaml
```

## Delete Deployment

```bash
kubectl delete -f manifests/nginx-deployment.yaml
```

---

# Cleanup Azure Resources

## Delete AKS

```bash
az aks delete \
  --resource-group aks-bootcamp-rg \
  --name aks-bootcamp \
  --yes
```

## Delete ACR

```bash
az acr delete \
  --name aksbootcampacr01 \
  --yes
```

## Delete Resource Group

```bash
az group delete \
  --name aks-bootcamp-rg \
  --yes
```

---

# Verification Commands

## Verify Cluster Resources

```bash
kubectl get all
```

## Verify Ingress

```bash
kubectl get ingress
```

## Verify HPA

```bash
kubectl get hpa
```

## Verify AKS Removal

```bash
az aks list -o table
```

## Verify ACR Removal

```bash
az acr list -o table
```

## Verify Resource Groups

```bash
az group list -o table
```
