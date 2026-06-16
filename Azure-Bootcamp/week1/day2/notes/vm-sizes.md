# VM Size Study & Conclusions

## Why Azure Has So Many VM Sizes

Azure provides hundreds of VM sizes because different workloads require different combinations of:

* CPU
* Memory (RAM)
* Storage
* Disk Performance (IOPS)
* Network Throughput
* GPU Acceleration

A web server, database server, machine learning workload, and big data cluster all have different requirements. Instead of one VM type, Azure offers specialized VM families.

---

# VM Family Classification

## B-Series (Burstable)

Purpose:
Low-cost workloads that are idle most of the time but occasionally require CPU bursts.

Examples:

* Personal projects
* Learning environments
* Development VMs
* Small websites

Advantages:

* Cheapest VMs
* Eligible for free tier offerings
* Good for labs and testing

Disadvantages:

* Limited sustained CPU performance
* Not suitable for production workloads with constant traffic

Example:

B2ats_v2

* 2 vCPU
* 1 GB RAM

This was used during Azure Bootcamp Day 2.

---

## D-Series (General Purpose)

Purpose:
Balanced CPU and memory.

Most common VM family in Azure.

Examples:

* Web servers
* APIs
* Backend services
* Jenkins servers
* Kubernetes worker nodes

Advantages:

* Balanced performance
* Reliable production workload support
* Most frequently deployed VM family

Example:

D2as_v5

* 2 vCPU
* 8 GB RAM

Rule:

When unsure, choose D-Series.

---

## E-Series (Memory Optimized)

Purpose:
High memory workloads.

Examples:

* PostgreSQL
* MySQL
* SQL Server
* Redis
* Elasticsearch

Characteristics:

Same CPU count as D-Series but significantly more RAM.

Example:

E2as_v5

* 2 vCPU
* 16 GB RAM

Rule:

Databases usually prefer E-Series.

---

## F-Series (Compute Optimized)

Purpose:
CPU-intensive workloads.

Examples:

* Build servers
* Video encoding
* Scientific computing
* Rendering
* High-performance batch processing

Characteristics:

More CPU power relative to RAM.

Rule:

Choose F-Series when CPU is the bottleneck.

---

## L-Series (Storage Optimized)

Purpose:
Storage-heavy workloads.

Examples:

* Big data
* Elasticsearch
* Analytics platforms
* Log aggregation systems

Characteristics:

Large local disks and high IOPS.

Rule:

Choose L-Series when disk performance matters most.

---

## N-Series (GPU)

Purpose:
Machine Learning and AI.

Examples:

* Deep Learning
* LLM Training
* Computer Vision
* Stable Diffusion

Characteristics:

NVIDIA GPUs attached to VM.

Examples:

* T4
* A100
* H100

Rule:

Choose N-Series for AI workloads.

---

## M-Series (Massive Memory)

Purpose:
Enterprise databases.

Examples:

* SAP HANA
* Large in-memory databases

Characteristics:

Extremely high RAM capacities.

Rule:

Rarely used except in large enterprises.

---

# Understanding VM Naming

Example:

D2ads_v5

Breakdown:

D = General Purpose Family

2 = Number of vCPUs

a = AMD Processor

d = Local Temporary Disk

s = Premium SSD Support

v5 = Generation 5 Hardware

---

# Regional Observations

During Azure Bootcamp we explored:

## Central India

Mostly:

* D-Series v5
* E-Series v5
* B-Series v2

Observations:

* Lower pricing
* Good latency for Indian users
* Some VM sizes may have temporary capacity restrictions

---

## Korea Central

Observations:

* Similar VM families available
* Different pricing
* Different hardware availability

---

## East US

Observations:

* Largest Azure region
* Newest VM generations appear first
* D-Series v7 available
* E-Series v7 available

Conclusion:

Not every Azure region receives the newest hardware generation at the same time.

---

# What Most Companies Use

Web Servers:
D-Series

APIs:
D-Series

CI/CD Servers:
D-Series

AKS Worker Nodes:
D-Series

Databases:
E-Series

Machine Learning:
N-Series

Learning Labs:
B-Series

---

# Personal Bootcamp Conclusion

For Azure learning and DevOps practice:

Recommended:

* B2ats_v2
* B2as_v2

For AKS learning:

* D2as_v5
* D2s_v5

For database experiments:

* E2as_v5

For AI experiments:

* N-Series (only when required due to high cost)

---

# Golden Rule

If workload type is known:

Learning → B-Series

General Purpose → D-Series

Database → E-Series

Compute Intensive → F-Series

Storage Intensive → L-Series

AI / GPU → N-Series

Enterprise Memory Workloads → M-Series

Remembering this mapping solves approximately 90% of Azure VM selection scenarios.
