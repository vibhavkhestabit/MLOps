# Azure Bootcamp - Week 2 Day 1
# AKS Fundamentals - Commands Reference

## Exercise 1.1 - Create Resource Group

```bash
az group create \
  --name aks-bootcamp-rg \
  --location centralindia
```

Creates a logical container for all Azure resources used in this lab.

---

## Verify Resource Groups

```bash
az group list --output table
```

Lists all resource groups in the subscription.

---

## Check Available VM Quotas

```bash
az vm list-usage \
  --location centralindia \
  --output table
```

Displays regional vCPU limits and VM family quotas.

---

## Create AKS Cluster

```bash
az aks create \
  --resource-group aks-bootcamp-rg \
  --name aks-bootcamp \
  --node-count 1 \
  --node-vm-size Standard_B2pls_v2 \
  --tier free \
  --generate-ssh-keys
```

Creates an AKS cluster with:

- 1 worker node
- Free control plane
- B-Series VM
- Managed Kubernetes

---

## Exercise 1.2 - Connect kubectl to AKS

```bash
az aks get-credentials \
  --resource-group aks-bootcamp-rg \
  --name aks-bootcamp
```

Downloads kubeconfig and connects kubectl to AKS.

---

## Verify Current Kubernetes Context

```bash
kubectl config current-context
```

Shows which Kubernetes cluster kubectl is currently targeting.

---

## Show Cluster Information

```bash
kubectl cluster-info
```

Displays API Server and cluster service endpoints.

---

# Exercise 1.3 - Verify Cluster

## View Worker Nodes

```bash
kubectl get nodes
```

Lists all Kubernetes worker nodes.

---

## View Detailed Node Information

```bash
kubectl get nodes -o wide
```

Displays:

- Internal IP
- OS
- Kubernetes Version
- Container Runtime

---

## View Namespaces

```bash
kubectl get namespaces
```

Lists all namespaces in the cluster.

---

## View System Pods

```bash
kubectl get pods -n kube-system
```

Displays core Kubernetes and Azure-managed services.

Examples:

- CoreDNS
- Metrics Server
- Azure CNS
- Azure File CSI Driver
- Azure Disk CSI Driver
- Kube Proxy

---

## View All Resources

```bash
kubectl get all -A
```

Displays all resources across all namespaces.

---

## View Services

```bash
kubectl get svc -A
```

Displays all cluster services.

---

## View Deployments

```bash
kubectl get deployments -A
```

Displays all deployments.

---

## View DaemonSets

```bash
kubectl get daemonsets -A
```

Displays node-level workloads.

---

## View ReplicaSets

```bash
kubectl get rs -A
```

Displays deployment-managed replicas.

---

# Metrics Server

## Node Metrics

```bash
kubectl top nodes
```

Shows:

- CPU Usage
- Memory Usage

Provided by Metrics Server.

---

## Pod Metrics

```bash
kubectl top pods -A
```

Shows resource usage of all pods.

---

# Exercise 1.4 - Azure Container Registry

## List Registries

```bash
az acr list --output table
```

Displays available ACR registries.

---

## Create Registry

```bash
az acr create \
  --resource-group aks-bootcamp-rg \
  --name aksbootcampacr01 \
  --sku Basic
```

Creates Azure Container Registry.

---

## Show Registry Details

```bash
az acr show \
  --name aksbootcampacr01
```

Displays ACR configuration.

---

## Attach ACR to AKS

```bash
az aks update \
  --resource-group aks-bootcamp-rg \
  --name aks-bootcamp \
  --attach-acr aksbootcampacr01
```

Allows AKS to pull private images from ACR.

---

# AKS Discovery Commands

## Show Cluster Details

```bash
az aks show \
  --resource-group aks-bootcamp-rg \
  --name aks-bootcamp
```

Displays complete cluster configuration.

---

## Show Node Pools

```bash
az aks nodepool list \
  --resource-group aks-bootcamp-rg \
  --cluster-name aks-bootcamp \
  -o table
```

Displays worker node pool configuration.

---

## Show Azure Resources Created by AKS

```bash
az resource list \
  --resource-group MC_aks-bootcamp-rg_aks-bootcamp_centralindia \
  -o table
```

Lists automatically created AKS resources.

Examples:

- VM Scale Set
- Load Balancer
- VNet
- NSG
- Managed Identity
- Public IP

---

# Cleanup Commands

## Delete AKS Cluster

```bash
az aks delete \
  --resource-group aks-bootcamp-rg \
  --name aks-bootcamp
```

Deletes AKS and managed resources.

---

## Delete Resource Group

```bash
az group delete \
  --name aks-bootcamp-rg \
  --yes
```

Deletes all resources inside the resource group.