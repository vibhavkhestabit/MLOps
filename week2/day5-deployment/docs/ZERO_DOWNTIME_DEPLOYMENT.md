#  ZERO_DOWNTIME_DEPLOYMENT.md

## Zero-Downtime Deployment Procedures (Blue-Green)
**Author:** Vibhav Khaneja 

## Strategy Overview
To achieve true zero-downtime during major releases, Stack 1 utilizes a **Blue-Green Deployment** strategy managed via Nginx upstream toggling and PM2.

## The Blue-Green Architecture
*   **Blue Environment (Active):** Ports 3000, 3003, 3004
*   **Green Environment (Inactive):** Ports 3010, 3013, 3014

## Execution Flow
Execute the automation script:
```
./scripts/zero_downtime_deploy.sh
```

## Automated Steps Performed:

1) Background Initialization: PM2 spins up the inactive environment (e.g., Green) without affecting live traffic.
2) Health Verification: The script probes http://127.0.0.1:$PORT/api/health for the newly launched instances. If any instance returns a non-200 HTTP code, the deployment aborts immediately, leaving the Blue environment untouched.
3) Traffic Cutover: Using sed, the script updates the Nginx upstream block to point proxy_pass to the new environment and issues a systemctl reload nginx for a graceful, dropless connection handoff.
4) Decommissioning: The old instances are spun down via PM2 to free system resources.

![ss](../screenshots/zero_downtime.png)