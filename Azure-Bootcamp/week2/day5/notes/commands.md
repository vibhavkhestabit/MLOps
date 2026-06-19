# Week 2 Day 5 Commands

## Verify AKS

```bash
kubectl get nodes
kubectl get pods
kubectl get svc
```

## Create Log Analytics Workspace

```bash
az monitor log-analytics workspace create \
  --resource-group rg-azure-devops-day4 \
  --workspace-name law-aks-day5 \
  --location centralindia
```

## Get Workspace ID

```bash
WORKSPACE_ID=$(az monitor log-analytics workspace show \
  --resource-group rg-azure-devops-day4 \
  --workspace-name law-aks-day5 \
  --query id \
  -o tsv)
```

## Register Monitoring Provider

```bash
az provider register \
  --namespace Microsoft.Insights
```

## Enable Monitoring

```bash
az aks enable-addons \
  --resource-group rg-azure-devops-day4 \
  --name aks-day4 \
  --addons monitoring \
  --workspace-resource-id $WORKSPACE_ID
```

## Verify Monitoring Agents

```bash
kubectl get pods -n kube-system
```

## Explore Logs

```kql
KubePodInventory
| take 10
```

## CPU Metrics

```kql
InsightsMetrics
| take 20
```

## Create Stress Pod

```bash
kubectl apply -f manifests/stress-pod.yaml
```

## Monitor CPU

```bash
kubectl top pod
kubectl top node
```

## Cleanup

```bash
kubectl delete pod stress-pod
```