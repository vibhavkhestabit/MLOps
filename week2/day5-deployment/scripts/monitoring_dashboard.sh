#!/bin/bash
# ==============================================================================
# Script Name: monitoring_dashboard.sh
# Description: Real-time centralized monitoring dashboard for all application stacks.
# Author: Vibhav Khaneja
# Date: 2026-05-01
# ==============================================================================

# Setup Logging Directory
LOG_DIR="/home/$USER/MLOps-Training/week2/day5-deployment/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/monitoring_dashboard_$(date +%Y%m%d).log"

# Color Codes
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color
CLEAR='\033[2J\033[H'

echo "Dashboard initialized. Logging to $LOG_FILE" > "$LOG_FILE"

while true; do
    echo -ne "${CLEAR}"
    TIMESTAMP=$(date +'%Y-%m-%d %H:%M:%S')
    echo "================================================================"
    echo "       DEVOPS BOOTCAMP MONITORING DASHBOARD - $TIMESTAMP"
    echo "================================================================"
    
    # --- SYSTEM RESOURCES ---
    echo -e "\n${YELLOW}>>> SYSTEM RESOURCES${NC}"
    CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1}')
    RAM_USAGE=$(free -m | awk 'NR==2{printf "%.2f%%", $3*100/$2 }')
    DISK_USAGE=$(df -h / | awk '$NF=="/"{printf "%s", $5}')
    
    echo "CPU Load: ${CPU_USAGE}% | RAM: ${RAM_USAGE} | Disk: ${DISK_USAGE}"

    # --- STACK 1: Node.js + Next.js (PM2) ---
    echo -e "\n${YELLOW}>>> STACK 1 (Next.js + Node.js + MongoDB)${NC}"
    # FIX: Parse standard list output and ensure they are 'online'
    S1_BACKEND=$(pm2 list | grep "nodejs-api-300" | grep -c "online")
    S1_FRONTEND=$(pm2 list | grep "nextjs-app-300" | grep -c "online")
    
    if [ "$S1_BACKEND" -ge 3 ] && [ "$S1_FRONTEND" -ge 2 ]; then
        echo -e "Status: ${GREEN}HEALTHY${NC}"
        S1_STATUS="HEALTHY"
    else
        echo -e "Status: ${RED}DEGRADED${NC} (Check PM2 logs)"
        S1_STATUS="DEGRADED"
    fi
    echo "Backend Instances: ${S1_BACKEND}/3 UP | Frontend Instances: ${S1_FRONTEND}/2 UP"

    # --- STACK 2: Laravel + MySQL (Systemd) ---
    echo -e "\n${YELLOW}>>> STACK 2 (Laravel + MySQL)${NC}"
    S2_8000=$(systemctl is-active laravel-app-8000)
    S2_8001=$(systemctl is-active laravel-app-8001)
    S2_8002=$(systemctl is-active laravel-app-8002)
    S2_WORKER=$(systemctl is-active laravel-worker)
    
    if [ "$S2_8000" == "active" ] && [ "$S2_8001" == "active" ] && [ "$S2_8002" == "active" ]; then
        echo -e "Status: ${GREEN}HEALTHY${NC}"
        S2_STATUS="HEALTHY"
    else
        echo -e "Status: ${RED}DEGRADED${NC} (Check Systemd status)"
        S2_STATUS="DEGRADED"
    fi
    echo "Laravel API Ports: 8000($S2_8000) | 8001($S2_8001) | 8002($S2_8002)"
    echo "Queue Worker: $S2_WORKER"

    # --- STACK 3: FastAPI + Next.js (Systemd + PM2) ---
    echo -e "\n${YELLOW}>>> STACK 3 (Next.js + FastAPI + MySQL)${NC}"
    S3_8003=$(systemctl is-active fastapi-app-8003)
    S3_8004=$(systemctl is-active fastapi-app-8004)
    S3_8005=$(systemctl is-active fastapi-app-8005)
    S3_FRONTEND=$(pm2 list | grep "stack3-nextjs-300" | grep -c "online")
    
    if [ "$S3_8003" == "active" ] && [ "$S3_8004" == "active" ] && [ "$S3_8005" == "active" ] && [ "$S3_FRONTEND" -ge 2 ]; then
        echo -e "Status: ${GREEN}HEALTHY${NC}"
        S3_STATUS="HEALTHY"
    else
        echo -e "Status: ${RED}DEGRADED${NC} (Check PM2/Systemd logs)"
        S3_STATUS="DEGRADED"
    fi
    echo "FastAPI API Ports: 8003($S3_8003) | 8004($S3_8004) | 8005($S3_8005)"
    echo "Frontend Instances: ${S3_FRONTEND}/2 UP"

    echo -e "\n================================================================"
    echo "Refreshing every 5 seconds. Press [CTRL+C] to exit."
    
    # Background Logging
    echo "[$TIMESTAMP] CPU:${CPU_USAGE}% | RAM:${RAM_USAGE} | STACK1:${S1_STATUS} | STACK2:${S2_STATUS} | STACK3:${S3_STATUS}" >> "$LOG_FILE"
    
    sleep 5
done