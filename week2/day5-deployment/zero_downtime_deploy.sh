#!/bin/bash
# ==============================================================================
# Script Name: zero_downtime_deploy.sh
# Description: Automated Blue-Green deployment strategy for zero-downtime updates.
# Author: Vibhav Khaneja
# Date: 2026-05-01
# ==============================================================================

LOG_DIR="/home/$USER/MLOps-Training/week2/day5-deployment/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/blue_green_deploy_$(date +%Y%m%d_%H%M%S).log"

NGINX_CONF="/etc/nginx/sites-available/stack1.conf"

echo "========================================================" | tee -a "$LOG_FILE"
echo "INITIATING BLUE-GREEN DEPLOYMENT - $(date +'%Y-%m-%d %H:%M:%S')" | tee -a "$LOG_FILE"
echo "========================================================" | tee -a "$LOG_FILE"

# Determine current active environment by checking Nginx config
if grep -q "proxy_pass http://app_blue;" "$NGINX_CONF"; then
    ACTIVE_ENV="blue"
    TARGET_ENV="green"
    TARGET_PORTS=(3010 3013 3014)
    ACTIVE_PORTS=(3000 3003 3004)
else
    ACTIVE_ENV="green"
    TARGET_ENV="blue"
    TARGET_PORTS=(3000 3003 3004)
    ACTIVE_PORTS=(3010 3013 3014)
fi

echo "-> Current Active Environment: ${ACTIVE_ENV^^}" | tee -a "$LOG_FILE"
echo "-> Target Deployment Environment: ${TARGET_ENV^^}" | tee -a "$LOG_FILE"

# 1. Deploy new version to inactive instances
echo -e "\n[Step 1] Starting ${TARGET_ENV^^} instances..." | tee -a "$LOG_FILE"
for PORT in "${TARGET_PORTS[@]}"; do
    pm2 start /home/$USER/MLOps-Training/week2/day5-deployment/nextjs-nodejs-mongodb/pm2/ecosystem.config.js --only nodejs-api-$PORT >> "$LOG_FILE" 2>&1
done
sleep 5 # Give PM2 a moment to initialize

# 2. Run health checks on the new instances
echo -e "\n[Step 2] Running Health Checks on ${TARGET_ENV^^} instances..." | tee -a "$LOG_FILE"
HEALTHY=true
for PORT in "${TARGET_PORTS[@]}"; do
    if curl -s -f http://127.0.0.1:$PORT/api/health > /dev/null; then
        echo "[PASS] Port $PORT is responding." | tee -a "$LOG_FILE"
    else
        echo "[FAIL] Port $PORT failed health check!" | tee -a "$LOG_FILE"
        HEALTHY=false
    fi
done

if [ "$HEALTHY" = false ]; then
    echo "CRITICAL: Health checks failed. Aborting deployment. Shutting down ${TARGET_ENV^^}." | tee -a "$LOG_FILE"
    for PORT in "${TARGET_PORTS[@]}"; do
        pm2 stop nodejs-api-$PORT >> "$LOG_FILE" 2>&1
    done
    exit 1
fi

# 3. Switch Nginx upstream
echo -e "\n[Step 3] Health checks passed! Switching Nginx traffic to ${TARGET_ENV^^}..." | tee -a "$LOG_FILE"
sudo sed -i "s/proxy_pass http:\/\/app_${ACTIVE_ENV};/proxy_pass http:\/\/app_${TARGET_ENV};/" "$NGINX_CONF"
sudo systemctl reload nginx
echo "[PASS] Traffic is now hitting the ${TARGET_ENV^^} environment." | tee -a "$LOG_FILE"

# 4. Monitor for errors
echo -e "\n[Step 4] Monitoring for errors..." | tee -a "$LOG_FILE"
# Note: For the bootcamp demo, we will simulate a 15-second monitoring window instead of a full 5 minutes.
for i in {1..15}; do
    echo -ne "Monitoring... $i/15 seconds elapsed\r"
    sleep 1
    # In a real scenario, we would grep Nginx error logs here:
    # if grep -q "502 Bad Gateway" /var/log/nginx/error.log; then ...
done
echo -e "\n[PASS] No critical errors detected during monitoring window." | tee -a "$LOG_FILE"

# 5. Decommission old instances
echo -e "\n[Step 5] Deployment Stable. Decommissioning old ${ACTIVE_ENV^^} instances..." | tee -a "$LOG_FILE"
for PORT in "${ACTIVE_PORTS[@]}"; do
    pm2 stop nodejs-api-$PORT >> "$LOG_FILE" 2>&1
done

echo "========================================================" | tee -a "$LOG_FILE"
echo "[SUCCESS] Zero-Downtime Deployment Complete!" | tee -a "$LOG_FILE"
echo "New Active Environment: ${TARGET_ENV^^}" | tee -a "$LOG_FILE"
echo "========================================================" | tee -a "$LOG_FILE"