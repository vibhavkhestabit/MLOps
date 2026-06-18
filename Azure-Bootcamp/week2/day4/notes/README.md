# Azure Bootcamp - Week 2 Day 4

# Full CI/CD Pipeline (Azure DevOps → ACR → AKS)

## Objective

The goal of Day 4 was to build a complete CI/CD pipeline where a code change automatically triggers:

1. Docker image build
2. Image push to Azure Container Registry (ACR)
3. Deployment to Azure Kubernetes Service (AKS)

By the end of the day we achieved a fully automated deployment workflow using Azure DevOps Pipelines.

---

# Architecture Overview

```text
Git Push
   │
   ▼
Azure DevOps Pipeline
   │
   ├── Build Docker Image
   │
   ├── Push Image to ACR
   │
   └── Deploy to AKS
           │
           ▼
      Kubernetes Deployment
           │
           ▼
      Running Pods
           │
           ▼
      Public Application
```

---

# Exercise 4.1 - Docker Build Stage

A Docker build stage was added to the Azure DevOps pipeline using the Docker@2 task.

The pipeline automatically builds the application image whenever code is pushed to the main branch.

This removes the need for manual Docker builds on local machines.

---

# Exercise 4.2 - Authenticate Pipeline to ACR

Instead of storing credentials inside YAML files, an Azure DevOps Service Connection was used.

Service Connection:

```text
acr-connection
```

This allows Azure DevOps to securely authenticate with Azure Container Registry and push images without exposing usernames or passwords.

---

# Exercise 4.3 - Push Images with Build ID Tags

The pipeline was configured to tag images using:

```text
$(Build.BuildId)
```

Example:

```text
vibhavacrday4.azurecr.io/flask-app:9
```

and

```text
vibhavacrday4.azurecr.io/flask-app:latest
```

Benefits:

* Every deployment is traceable
* Easy rollback to previous versions
* Unique image versions for every pipeline execution

---

# Real Production Debugging

During deployment we encountered:

```text
ImagePullBackOff
```

Investigation revealed that:

* AKS nodes were running ARM64 architecture
* The Docker image contained only AMD64 layers

Verification:

```bash
kubectl get node -o jsonpath='{.items[0].status.nodeInfo.architecture}'
```

Output:

```text
arm64
```

The image was rebuilt using Docker Buildx with support for both architectures:

```bash
docker buildx build \
--platform linux/amd64,linux/arm64
```

This produced a multi-architecture image that AKS could successfully pull.

This was one of the most important practical learnings of the day.

---

# Exercise 4.4 - Deploy to AKS

A deployment stage was added to the pipeline.

The pipeline performs:

```bash
kubectl set image deployment/flask-app \
flask-app=<new-image>
```

This updates the running deployment without manually editing manifests.

The deployment process is now fully automated.

---

# Exercise 4.5 - End-to-End Automated Deployment

The final workflow became:

```text
Code Change
    │
    ▼
Git Push
    │
    ▼
Azure DevOps Pipeline
    │
    ▼
Build Image
    │
    ▼
Push to ACR
    │
    ▼
Deploy to AKS
    │
    ▼
Running Application Updated
```

No manual Docker commands or kubectl image updates are required.

---

# Exercise 4.6 - Environment-Based Deployment

The deployment stage was configured using Azure DevOps Environments.

Environment:

```text
production
```

This allows future enhancements such as:

* Manual approvals
* Quality gates
* Production deployment controls

---

# Exercise 4.7 - Rolling Updates and Zero Downtime

The Kubernetes Deployment uses:

```text
StrategyType: RollingUpdate
```

Configuration:

```text
maxUnavailable: 0
maxSurge: 1
```

Benefits:

* Existing pods remain available
* New pods are created before old pods are removed
* No downtime during deployments

This is the standard deployment strategy used in production Kubernetes environments.

---


# Screenshots

![ss](../screenshots/ss1.png)
![ss](../screenshots/ss2.png)
![ss](../screenshots/ss3.png)
![ss](../screenshots/ss4.png)
![ss](../screenshots/ss5.png)
![ss](../screenshots/ss6.png)
![ss](../screenshots/ss7.png)
![ss](../screenshots/ss8.png)
![ss](../screenshots/ss9.png)
![ss](../screenshots/ss10.png)
![ss](../screenshots/ss11.png)
![ss](../screenshots/ss12.png)
![ss](../screenshots/ss13.png)
![ss](../screenshots/ss14.png)
![ss](../screenshots/ss15.png)
![ss](../screenshots/ss16.png)
![ss](../screenshots/ss17.png)
![ss](../screenshots/ss18.png)
![ss](../screenshots/ss19.png)
![ss](../screenshots/ss20.png)
![ss](../screenshots/ss21.png)
![ss](../screenshots/ss22.png)
![ss](../screenshots/ss23.png)
![ss](../screenshots/ss24.png)
![ss](../screenshots/ss25.png)
![ss](../screenshots/ss26.png)

# Key Learnings

* Azure DevOps can automate the complete CI/CD workflow.
* Service Connections provide secure authentication.
* Image tagging using Build IDs enables version tracking and rollback.
* AKS deployments can be updated automatically using pipeline stages.
* ARM64 vs AMD64 architecture compatibility is an important real-world consideration.
* Multi-architecture images solve cross-platform deployment issues.
* Rolling updates provide zero-downtime deployments.
* CI/CD pipelines significantly reduce manual operational effort.

Day 4 transformed the workflow from manual deployments into a fully automated production-style delivery pipeline.
