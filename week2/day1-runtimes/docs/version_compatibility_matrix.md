# Version Compatibility Matrix

## Overview
This document outlines the specific runtime versions provisioned across our infrastructure. Maintaining a strict compatibility matrix ensures our application layers—ranging from legacy PHP monoliths to modern Python-based AI microservices—execute predictably across development, staging, and production environments.

We strictly avoid relying on OS-level default package managers (like `apt` for Node/Python) for our core runtimes to prevent forced upgrades from breaking application dependencies.

## 1. Node.js Environments
Managed via `nvm`. Node.js serves as the backbone for our high-concurrency gateway APIs and server-side rendered (SSR) frontends. 

| Version | Status | Primary Architectural Target |
| :--- | :--- | :--- |
| **v20.11.0** | **DEFAULT** | **Active LTS.** This is our primary target for production. Fully validated against our Express.js APIs and Next.js applications. |
| **v18.19.0** | ACTIVE | Maintenance LTS. Retained strictly for backwards compatibility when legacy npm packages fail to compile against the v20 V8 engine. |
| **v22.0.0** | TESTING | Current Release. Isolated for local development and testing upcoming ECMAScript features. Not cleared for production deployments. |

## 2. Python Environments
Managed via `pyenv`. Python handles our data-intensive workloads, machine learning pipelines, and asynchronous backend services.

| Version | Status | Primary Architectural Target |
| :--- | :--- | :--- |
| **3.11.7** | **DEFAULT** | **Production Target.** The optimal balance of speed and package support. Drives our FastAPI microservices and Retrieval-Augmented Generation (RAG) agent orchestrations. |
| **3.12.1** | ACTIVE | Latest stable. Excellent performance, but some compiled C-extensions in older data science libraries lack full support. Used for lightweight scripts. |
| **3.10.13** | ACTIVE | Legacy fallback. Specifically maintained for older PyTorch/TensorFlow models that have strictly pinned dependency trees. |
| **3.9.18** | DEPRECATED| Kept in the environment only to support legacy automated maintenance scripts that have not yet been refactored. |

## 3. PHP Environments
Managed via `apt` (Ondrej PPA) with `update-alternatives`. PHP handles our traditional MVC web applications and background queue processing.

| Version | Status | Primary Architectural Target |
| :--- | :--- | :--- |
| **8.2.15** | **DEFAULT** | **Production Target.** The standard runtime for our modern Laravel deployments. Provides the best balance of strict typing and execution speed. |
| **8.3.2** | ACTIVE | Latest release. Currently used in parallel staging environments to test codebase refactors against upcoming language deprecations. |
| **8.1.27** | ACTIVE | Active legacy. Maintained for applications currently transitioning out of older architectural patterns that throw warnings under 8.2's strict rules. |
| **7.4.33** | EOL | End of Life. Retained strictly for migrating out-of-date legacy systems. Applications running on 7.4 must be isolated behind strict reverse proxy rules. |