# Day 2 — Kubernetes Pods & Pod Management Commands

## Verify Cluster Status

```bash
kubectl get nodes
kubectl get pods -A
minikube status
```

---

# Exercise 1 — Simple Pod

## Create Pod

```bash
kubectl apply -f manifests/day2/simple-pod.yaml
```

## Watch Pod Lifecycle

```bash
kubectl get pods -w
```

## Get Pod Details

```bash
kubectl get pods
kubectl get pods -o wide
kubectl describe pod nginx-simple
```

## View Logs

```bash
kubectl logs nginx-simple
```

## Execute Commands Inside Pod

```bash
kubectl exec nginx-simple -- ls /usr/share/nginx/html
kubectl exec -it nginx-simple -- /bin/sh
```

## Port Forwarding

```bash
kubectl port-forward pod/nginx-simple 8080:80
```

Access in browser:

```text
http://localhost:8080
```

## Delete Pod

```bash
kubectl delete -f manifests/day2/simple-pod.yaml
```

---

# Exercise 2 — Resource Requests & Limits

## Apply Pod

```bash
kubectl apply -f manifests/day2/pod-with-resources.yaml
```

## Verify Pod

```bash
kubectl get pods
kubectl describe pod nginx-limited
```

## Check Resource Usage

```bash
kubectl top pod nginx-limited
```

## View YAML & JSON

```bash
kubectl get pod nginx-limited -o yaml
kubectl get pod nginx-limited -o json | less
```

## Delete Pod

```bash
kubectl delete -f manifests/day2/pod-with-resources.yaml
```

---

# Exercise 3 — Liveness & Readiness Probes

## Apply Pod

```bash
kubectl apply -f manifests/day2/pod-with-probes.yaml
```

## Watch Probe Behavior

```bash
kubectl get pods -w
kubectl describe pod nginx-probes
```

## Simulate Failure

```bash
kubectl exec -it nginx-probes -- /bin/sh
kill 1
```

## Observe Restart

```bash
kubectl get pods -w
kubectl describe pod nginx-probes
```

## Delete Pod

```bash
kubectl delete -f manifests/day2/pod-with-probes.yaml
```

---

# Exercise 4 — Multi-Container Pod

## Apply Pod

```bash
kubectl apply -f manifests/day2/multi-container-pod.yaml
```

## Verify Pod

```bash
kubectl get pods -o wide
```

## View Logs

```bash
kubectl logs webapp-with-sidecar -c webapp
kubectl logs webapp-with-sidecar -c log-reader
```

## Generate Traffic

```bash
kubectl exec webapp-with-sidecar -c webapp -- wget -qO- localhost
```

Run multiple times.

## Check Sidecar Logs

```bash
kubectl logs webapp-with-sidecar -c log-reader
```

## Delete Pod

```bash
kubectl delete -f manifests/day2/multi-container-pod.yaml
```

---

# Exercise 5 — Init Containers

## Apply Pod

```bash
kubectl apply -f manifests/day2/pod-with-init.yaml
```

## Watch Initialization

```bash
kubectl get pods -w
```

## View Init Container Logs

```bash
kubectl logs webapp-with-init -c init-setup
```

## Verify Shared Data

```bash
kubectl exec webapp-with-init -- cat /app-data/data/config.txt
```

## Delete Pod

```bash
kubectl delete -f manifests/day2/pod-with-init.yaml
```

---

# Exercise 6 — Pod Debugging

## Image Pull Failure

```bash
kubectl get pods failing-pod
kubectl describe pod failing-pod
kubectl delete pod failing-pod
```

## CrashLoopBackOff

```bash
kubectl get pods crash-pod -w
kubectl logs crash-pod
kubectl logs crash-pod --previous
kubectl delete pod crash-pod
```

---

# Exercise 7 — Debug Helper Script

## Make Script Executable

```bash
chmod +x day2/pod_debug.sh
```

## Run Script

```bash
./day2/pod_debug.sh webapp-with-sidecar
./day2/pod_debug.sh webapp-with-init
```

---

# Cleanup

## Delete Remaining Pods

```bash
kubectl delete -f manifests/day2/
```

## Verify Cleanup

```bash
kubectl get pods
```
