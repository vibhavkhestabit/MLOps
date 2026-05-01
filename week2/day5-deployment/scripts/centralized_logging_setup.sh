#!/bin/bash
# ==============================================================================
# Script Name: centralized_logging_setup.sh
# Description: Configures centralized log aggregation directories and log rotation.
# Author: Vibhav Khaneja
# Date: 2026-05-01
# ==============================================================================

LOG_DIR="/home/$USER/MLOps-Training/week2/day5-deployment/logs"
mkdir -p "$LOG_DIR"
SETUP_LOG="$LOG_DIR/logging_setup_$(date +%Y%m%d).log"

echo "========================================================" | tee -a "$SETUP_LOG"
echo "Setting up Centralized Logging - $(date +'%Y-%m-%d %H:%M:%S')" | tee -a "$SETUP_LOG"
echo "========================================================" | tee -a "$SETUP_LOG"

CENTRAL_DIR="/var/log/centralized"

echo "-> Creating structured directories in $CENTRAL_DIR..." | tee -a "$SETUP_LOG"
sudo mkdir -p $CENTRAL_DIR/{nginx,stack1,stack2,stack3}
sudo mkdir -p $CENTRAL_DIR/stack1/{nodejs-api,nextjs-app,mongodb}
sudo mkdir -p $CENTRAL_DIR/stack2/{laravel,mysql}
sudo mkdir -p $CENTRAL_DIR/stack3/{fastapi,nextjs,mysql}

sudo chown -R $USER:$USER $CENTRAL_DIR
echo "[PASS] Directory structure created." | tee -a "$SETUP_LOG"

echo "-> Configuring Logrotate..." | tee -a "$SETUP_LOG"
cat <<EOF | sudo tee /etc/logrotate.d/devops_centralized > /dev/null
/var/log/centralized/*/*.log
/var/log/centralized/*/*/*.log
{
    daily
    missingok
    rotate 30
    compress
    delaycompress
    notifempty
    create 0640 $USER $USER
}
EOF

echo "[PASS] Logrotate configuration applied for 30-day retention." | tee -a "$SETUP_LOG"

echo "========================================================" | tee -a "$SETUP_LOG"
echo "[SUCCESS] Centralized Logging Infrastructure Ready!" | tee -a "$SETUP_LOG"
echo "========================================================" | tee -a "$SETUP_LOG"