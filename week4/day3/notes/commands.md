# DAY 3 — COMMANDS REFERENCE

## Verify Cluster Status

```bash
kubectl cluster-info

kubectl get nodes

kubectl get all
```

---

# Exercise 1 — Deployments & ReplicaSets

## Validate Manifest

```bash
kubectl apply --dry-run=client -f manifests/day3/nginx-deployment.yaml
```

## Create Deployment

```bash
kubectl apply -f manifests/day3/nginx-deployment.yaml
```

## Verify Deployment

```bash
kubectl get deployments

kubectl get deploy
```

## Verify ReplicaSets

```bash
kubectl get rs
```

## Verify Pods

```bash
kubectl get pods

kubectl get pods -o wide
```

## Inspect Deployment

```bash
kubectl describe deployment nginx-deployment
```

---

# Exercise 2 — Scaling Deployments

## Check Current Replica Count

```bash
kubectl get deployment nginx-deployment
```

## Scale Up

```bash
kubectl scale deployment nginx-deployment --replicas=5
```

## Watch Pod Creation

```bash
kubectl get pods -w
```

## Scale Down

```bash
kubectl scale deployment nginx-deployment --replicas=2
```

## Restore Replica Count

```bash
kubectl scale deployment nginx-deployment --replicas=3
```

## Verify Scaling

```bash
kubectl get deploy

kubectl get rs

kubectl get pods
```

---

# Exercise 3 — Rolling Updates

## Apply Updated Deployment

```bash
kubectl apply -f manifests/day3/nginx-deployment-v2.yaml
```

## Monitor Rollout

```bash
kubectl rollout status deployment/nginx-deployment
```

## Watch Pods

```bash
kubectl get pods -w
```

## Watch ReplicaSets

```bash
kubectl get rs -w
```

## Verify Deployment

```bash
kubectl get deploy

kubectl get rs

kubectl get pods
```

---

# Exercise 4 — Rollbacks

## View Revision History

```bash
kubectl rollout history deployment/nginx-deployment
```

## Roll Back to Previous Revision

```bash
kubectl rollout undo deployment/nginx-deployment
```

## Verify Rollback

```bash
kubectl rollout status deployment/nginx-deployment

kubectl describe deployment nginx-deployment | grep Image
```

## Roll Forward Again

```bash
kubectl apply -f manifests/day3/nginx-deployment-v2.yaml
```

---

# Exercise 5 — Update Images

## View Current Image

```bash
kubectl describe deployment nginx-deployment | grep Image
```

## Update Container Image

```bash
kubectl set image deployment/nginx-deployment nginx=nginx:1.26-alpine
```

## Verify Update

```bash
kubectl rollout status deployment/nginx-deployment

kubectl describe deployment nginx-deployment | grep Image
```

## View Rollout History

```bash
kubectl rollout history deployment/nginx-deployment
```

---

# Exercise 6 — Custom Web Application Deployment

## Deploy Web Application

```bash
kubectl apply -f manifests/day3/webapp-deployment.yaml
```

## Verify Deployment

```bash
kubectl get deploy

kubectl get pods
```

## Inspect Pod

```bash
kubectl describe pod <pod-name>
```

## Port Forward

```bash
kubectl port-forward <pod-name> 8080:80
```

Access:

```text
http://localhost:8080
```

---

# Exercise 7 — Deployment Manager Script

## Make Script Executable

```bash
chmod +x day3/deployment_manager.sh
```

## Execute Script

```bash
./day3/deployment_manager.sh
```

---

# Rollout Commands

## Check Rollout Status

```bash
kubectl rollout status deployment/nginx-deployment
```

## Check Rollout History

```bash
kubectl rollout history deployment/nginx-deployment
```

## Roll Back

```bash
kubectl rollout undo deployment/nginx-deployment
```

---

# Useful Inspection Commands

## Get Complete Deployment YAML

```bash
kubectl get deployment nginx-deployment -o yaml
```

## Describe Deployment

```bash
kubectl describe deployment nginx-deployment
```

## Describe ReplicaSet

```bash
kubectl describe rs <replicaset-name>
```

## Describe Pod

```bash
kubectl describe pod <pod-name>
```

## View Events

```bash
kubectl get events
```

## View Logs

```bash
kubectl logs <pod-name>
```

---

# End-of-Day Cleanup

## Scale Deployments to Zero

```bash
kubectl scale deployment nginx-deployment --replicas=0

kubectl scale deployment webapp-deployment --replicas=0
```

## Verify Cleanup

```bash
kubectl get deploy

kubectl get pods
```

## Restore Tomorrow

```bash
kubectl scale deployment nginx-deployment --replicas=3

kubectl scale deployment webapp-deployment --replicas=3
```
