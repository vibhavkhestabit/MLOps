#!/bin/bash
# ==============================================================================
# Script Name: health_check_system.sh
# Description: Multi-level automated health checks for all deployed stacks.
# Author: Vibhav Khaneja
# Date: 2026-05-01
# ==============================================================================

LOG_DIR="/home/$USER/MLOps-Training/week2/day5-deployment/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/health_check_$(date +%Y%m%d).log"

echo "========================================================"
echo "Executing Comprehensive Stack Health Check..."
echo "Date: $(date +'%Y-%m-%d %H:%M:%S')"
echo "========================================================" | tee -a "$LOG_FILE"

# Function to check HTTP endpoints
check_endpoint() {
    local URL=$1
    local STACK_NAME=$2
    local RESPONSE=$(curl -s -w "%{http_code}" -o /dev/null "$URL" --connect-timeout 5)
    
    if [ "$RESPONSE" == "200" ]; then
        echo "[PASS] $STACK_NAME ($URL) is responding correctly." | tee -a "$LOG_FILE"
    else
        echo "[FAIL] $STACK_NAME ($URL) returned HTTP $RESPONSE! Initiating recovery..." | tee -a "$LOG_FILE"
        # Automated recovery logic could be triggered here
    fi
}

echo -e "\n--- Level 1: Infrastructure Checks ---" | tee -a "$LOG_FILE"
if systemctl is-active --quiet nginx; then
    echo "[PASS] Nginx Load Balancer is UP." | tee -a "$LOG_FILE"
else
    echo "[FAIL] Nginx is DOWN." | tee -a "$LOG_FILE"
fi

echo -e "\n--- Level 2 & 3: Application & Business Logic Checks ---" | tee -a "$LOG_FILE"

# Stack 1 Checks
echo "Checking Stack 1 (Node.js/Next.js/MongoDB)..."
check_endpoint "http://127.0.0.1:3000/api/health" "Stack 1 Node Backend (Port 3000)"
check_endpoint "http://127.0.0.1:3003/api/health" "Stack 1 Node Backend (Port 3003)"
check_endpoint "http://127.0.0.1:3004/api/health" "Stack 1 Node Backend (Port 3004)"
check_endpoint "http://127.0.0.1:3001" "Stack 1 Next.js Frontend (Port 3001)"
check_endpoint "http://127.0.0.1:3002" "Stack 1 Next.js Frontend (Port 3002)"

# Stack 2 Checks
echo "Checking Stack 2 (Laravel/MySQL)..."
check_endpoint "http://127.0.0.1:8000/api/health" "Stack 2 Laravel API (Port 8000)"
check_endpoint "http://127.0.0.1:8001/api/health" "Stack 2 Laravel API (Port 8001)"
check_endpoint "http://127.0.0.1:8002/api/health" "Stack 2 Laravel API (Port 8002)"

# Stack 3 Checks
echo "Checking Stack 3 (FastAPI/Next.js/MySQL)..."
check_endpoint "http://127.0.0.1:8003/api/health" "Stack 3 FastAPI Backend (Port 8003)"
check_endpoint "http://127.0.0.1:8004/api/health" "Stack 3 FastAPI Backend (Port 8004)"
check_endpoint "http://127.0.0.1:8005/api/health" "Stack 3 FastAPI Backend (Port 8005)"
check_endpoint "http://127.0.0.1:3005" "Stack 3 Next.js Frontend (Port 3005)"
check_endpoint "http://127.0.0.1:3006" "Stack 3 Next.js Frontend (Port 3006)"

echo "========================================================"
echo "Health check complete. Results logged to $LOG_FILE"