# Day 1 — Kubernetes Commands Reference

## Cluster Setup

```
minikube start --driver=docker
kubectl cluster-info
```

---

## Node Operations

```
kubectl get nodes
kubectl get nodes -o wide
kubectl describe node minikube
```

---

## Namespace Operations

```
kubectl get namespaces
kubectl get ns
```

---

## Pod Operations

```
kubectl get pods
kubectl get pods -A
kubectl get pods -o wide
kubectl get pods -o yaml
kubectl get pods -o json
```

---

## System Components

```
kubectl get pods -n kube-system
kubectl get componentstatuses
kubectl get events -A
```

---

## Dashboard

```
minikube addons enable dashboard
minikube addons enable metrics-server
minikube dashboard
minikube dashboard --url
```

---

## Pod Lifecycle

### Create Pod

```
kubectl run my-first-pod --image=nginx:alpine
```

### Monitor Pod

```
kubectl get pods
kubectl get pods -w
```

### Describe Pod

```
kubectl describe pod my-first-pod
```

### Logs

```
kubectl logs my-first-pod
```

### Execute Inside Pod

```
kubectl exec my-first-pod -- ls /usr/share/nginx/html
kubectl exec -it my-first-pod -- /bin/sh
```

### Delete Pod

```
kubectl delete pod my-first-pod
```

---

## kubectl Help

```
kubectl --help
kubectl get --help
kubectl explain pod
kubectl explain pod.spec
kubectl explain pod.spec.containers
```
