# Day 4 Commands — Kubernetes Services & Networking

## Verify Existing Deployments

```bash
kubectl get deployments
kubectl get pods -o wide
kubectl get rs
kubectl get svc
kubectl get all
```

---

## Exercise 1 — ClusterIP Service

### Create Service

```bash
kubectl apply -f manifests/day4/webapp-with-service.yaml
```

### Verify Service

```bash
kubectl get svc
kubectl describe svc webapp-service
kubectl get endpoints webapp-service
```

### Verify Pod IPs

```bash
kubectl get pods -o wide -l app=webapp
```

---

## Test Service Internally

```bash
kubectl run test-pod \
  --rm -it \
  --image=busybox:1.36 \
  --restart=Never \
  -- sh
```

Inside pod:

```sh
wget -qO- http://webapp-service

wget -qO- http://webapp-service.default.svc.cluster.local

nslookup webapp-service

exit
```

---

## Exercise 2 — NodePort Service

### Create NodePort Service

```bash
kubectl apply -f manifests/day4/webapp-nodeport.yaml
```

### Verify

```bash
kubectl get svc
kubectl describe svc webapp-nodeport
```

### Get Minikube IP

```bash
minikube ip
```

### Access Application

```bash
curl http://192.168.49.2:30080
```

Browser:

```text
http://192.168.49.2:30080
```

---

## Exercise 3 — DNS Discovery

### Create DNS Test Pod

```bash
kubectl apply -f manifests/day4/dns-test.yaml
```

### Verify Pod

```bash
kubectl get pod dns-test
```

### DNS Resolution Tests

```bash
kubectl exec dns-test -- nslookup webapp-service

kubectl exec dns-test -- nslookup webapp-service.default

kubectl exec dns-test -- nslookup webapp-service.default.svc.cluster.local
```

### Connectivity Test

```bash
kubectl exec dns-test -- wget -qO- http://webapp-service
```

### Inspect DNS Configuration

```bash
kubectl exec dns-test -- cat /etc/resolv.conf
```

---

## Exercise 4 — Multi-Tier Application

### Deploy Application

```bash
kubectl apply -f manifests/day4/multi-tier-app.yaml
```

### Watch Resources

```bash
kubectl get pods -w
```

### Verify

```bash
kubectl get deploy,svc,pods -l app=demo
```

### Access Frontend

```bash
curl http://192.168.49.2:30081
```

Browser:

```text
http://192.168.49.2:30081
```

### Frontend to Backend Communication

```bash
kubectl exec deploy/frontend -- wget -qO- http://backend-service
```

### Observe Load Balancing

```bash
for i in {1..10}; do
  kubectl exec deploy/frontend -- wget -qO- http://backend-service
  echo
done
```

---

## Exercise 5 — Service Testing Script

### Make Executable

```bash
chmod +x day4/service_test.sh
```

### Test Services

```bash
./day4/service_test.sh webapp-service

./day4/service_test.sh backend-service
```

---

## Cleanup Verification

```bash
kubectl get all
kubectl get svc
kubectl get endpoints
```
