# Comprehensive Deployment Guide

## Overview
This repository contains the deployment automation for a highly available, multi-language enterprise architecture consisting of three distinct stacks:
*   **Stack 1:** Node.js (Express) + Next.js + MongoDB Replica Set (PM2 Managed)
*   **Stack 2:** PHP (Laravel) + MySQL Master/Slave + Queue Workers (Systemd Managed)
*   **Stack 3:** Python (FastAPI) + Next.js + MySQL Read-Optimized (Hybrid Systemd/PM2 Managed)

## Prerequisites
*   Ubuntu Linux (20.04/22.04 LTS)
*   Nginx Load Balancer configured (`/etc/nginx/sites-available/`)
*   Redis Server (for caching)
*   PM2 globally installed (`npm install -g pm2`)
*   Appropriate language runtimes (Node.js v20, PHP 8.2, Python 3.11)

## Initial Deployment
For the initial rollout of the applications, utilize the deployment automation scripts located in the `scripts/` directory.

1.  **Stack 1 (Node.js/Next.js):**
    ```
    ./scripts/deploy_stack1.sh
    ```
    This script performs a rolling restart across PM2 cluster instances (Ports 3000, 3003, 3004) and verifies `/api/health` before proceeding.

![ss](../screenshots/deploy_stack1.png)
![ss](../screenshots/stack1_healthy.png)
![ss](../screenshots/stack1_health.png)
![ss](../screenshots/stack1_nextUI.png)

2.  **Stack 2 (Laravel):**
    ```
    ./scripts/deploy_stack2.sh
    ```
    Restarts Systemd services (`laravel-app-8000`, `8001`, `8002`) and background queue workers sequentially.

![ss](../screenshots/deploy_stack2.png)
![ss](../screenshots/stack2_healthy.png)
![ss](../screenshots/stack2_health.png)

3.  **Stack 3 (FastAPI/Next.js):**
    ```
    ./scripts/deploy_stack3.sh
    ```
    Performs a hybrid zero-downtime deployment, sequentially restarting the Python Systemd backend services (Ports 8003, 8004, 8005) and the Next.js PM2 frontend instances, verifying health status at each step.

![ss](../screenshots/deploy_stack3.png)
![ss](../screenshots/stack3_healthy.png)
![ss](../screenshots/stack3_nextUI.png)
