# Kubernetes Week 4 Final Project - Commands Reference

## Project Deployment

```bash
./scripts/deploy.sh
```

## Verify Deployments

```bash
kubectl get deploy
```

## Verify Pods

```bash
kubectl get pods
```

## Verify Services

```bash
kubectl get svc
```

## Verify Ingress

```bash
kubectl get ingress
```

## Frontend Test

```bash
curl http://$(minikube ip)/
```

## Backend API Test

```bash
curl http://$(minikube ip)/api
```

## Assets Service Test

```bash
curl http://$(minikube ip)/static
```

## Deployment Details

```bash
kubectl describe deployment frontend
kubectl describe deployment backend
kubectl describe deployment assets
```

## Service Details

```bash
kubectl describe svc frontend-service
kubectl describe svc backend-service
kubectl describe svc assets-service
```

## Ingress Details

```bash
kubectl describe ingress microservices-ingress
```

## Scale Frontend

```bash
kubectl scale deployment frontend --replicas=4
```

## Scale Backend

```bash
kubectl scale deployment backend --replicas=4
```

## Rollout Status

```bash
kubectl rollout status deployment/frontend
kubectl rollout status deployment/backend
kubectl rollout status deployment/assets
```

## Cleanup

```bash
./scripts/cleanup.sh
```
