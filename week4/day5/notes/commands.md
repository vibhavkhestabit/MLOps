# DAY 5 — Commands Reference

## Enable Ingress Controller

```bash
minikube addons enable ingress
```

```bash
kubectl wait --namespace ingress-nginx \
--for=condition=ready pod \
--selector=app.kubernetes.io/component=controller \
--timeout=120s
```

```bash
kubectl get pods -n ingress-nginx
```

```bash
kubectl get svc -n ingress-nginx
```

```bash
kubectl get deploy -n ingress-nginx
```

```bash
kubectl api-resources | grep ingress
```

---

## Deploy Applications

```bash
kubectl apply -f manifests/day5/ingress-apps.yaml
```

```bash
kubectl get deploy
```

```bash
kubectl get pods
```

```bash
kubectl get svc
```

---

## Internal Service Testing

```bash
kubectl run curl-test \
--image=curlimages/curl \
--restart=Never \
-- sleep 3600
```

```bash
kubectl exec curl-test -- curl web-main-service
```

```bash
kubectl exec curl-test -- curl api-service
```

```bash
kubectl exec curl-test -- curl admin-service
```

```bash
kubectl delete pod curl-test
```

---

## Path-Based Ingress

```bash
kubectl apply -f manifests/day5/ingress-path-based.yaml
```

```bash
kubectl get ingress
```

```bash
kubectl describe ingress path-based-ingress
```

```bash
MINIKUBE_IP=$(minikube ip)
```

```bash
curl http://$MINIKUBE_IP/
```

```bash
curl http://$MINIKUBE_IP/api
```

```bash
curl http://$MINIKUBE_IP/admin
```

---

## Host-Based Ingress

```bash
kubectl apply -f manifests/day5/ingress-host-based.yaml
```

```bash
kubectl get ingress
```

```bash
sudo nano /etc/hosts
```

Hosts entries:

```text
192.168.49.2 www.bootcamp.local
192.168.49.2 api.bootcamp.local
192.168.49.2 admin.bootcamp.local
```

---

## Host-Based Testing

```bash
curl http://www.bootcamp.local
```

```bash
curl http://api.bootcamp.local
```

```bash
curl http://admin.bootcamp.local
```

---

## Ingress Troubleshooting

```bash
kubectl get ingress
```

```bash
kubectl describe ingress
```

```bash
kubectl get svc
```

```bash
kubectl get pods
```

```bash
kubectl logs -n ingress-nginx POD_NAME
```

```bash
kubectl get events
```

---

## Ingress Test Script

```bash
chmod +x day5/ingress_test.sh
```

```bash
./day5/ingress_test.sh
```

---

## Cluster Verification

```bash
kubectl get deploy
```

```bash
kubectl get svc
```

```bash
kubectl get ingress
```

```bash
kubectl get pods
```

```bash
kubectl get all
```
