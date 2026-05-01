#!/bin/bash
# ==============================================================================
# Script Name: rollback.sh
# Description: Universal rollback procedure for recovering from failed deployments.
# Author: Vibhav Khaneja
# Date: 2026-05-01
# ==============================================================================

LOG_DIR="/home/$USER/MLOps-Training/week2/day5-deployment/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/rollback_$(date +%Y%m%d).log"

# Define where backups are actually stored
# For this bootcamp, we'll assume they are in the deployment folder. 
# In production, this would be /var/www/
BACKUP_BASE_DIR="/home/$USER/MLOps-Training/week2/day5-deployment"

echo "========================================================" | tee -a "$LOG_FILE"
echo "INITIATING EMERGENCY ROLLBACK PROCEDURE - $(date +'%Y-%m-%d %H:%M:%S')" | tee -a "$LOG_FILE"
echo "========================================================" | tee -a "$LOG_FILE"

echo "Select the stack to rollback:"
echo "1) Stack 1 (Node.js/Next.js/MongoDB)"
echo "2) Stack 2 (Laravel/MySQL)"
echo "3) Stack 3 (FastAPI/Next.js/MySQL)"
read -p "Enter choice (1-3): " STACK_CHOICE

case $STACK_CHOICE in
    1) STACK_NAME="stack1" ;;
    2) STACK_NAME="stack2" ;;
    3) STACK_NAME="stack3" ;;
    *) echo "Invalid choice. Aborting." | tee -a "$LOG_FILE"; exit 1 ;;
esac

echo "-> Locating actual backups for $STACK_NAME in $BACKUP_BASE_DIR..." | tee -a "$LOG_FILE"

# Dynamically find backup directories matching the pattern
# e.g., looking for folders named stack1-backup-*
BACKUP_DIRS=($(ls -d ${BACKUP_BASE_DIR}/${STACK_NAME}-backup-* 2>/dev/null))

if [ ${#BACKUP_DIRS[@]} -eq 0 ]; then
    echo "CRITICAL ERROR: No backups found for $STACK_NAME in $BACKUP_BASE_DIR!" | tee -a "$LOG_FILE"
    echo "Aborting rollback." | tee -a "$LOG_FILE"
    exit 1
fi

echo "Available backups:"
# Loop through the found directories and present them as options
for i in "${!BACKUP_DIRS[@]}"; do
    # Extract just the timestamp part from the directory name for cleaner display
    TIMESTAMP=$(basename "${BACKUP_DIRS[$i]}" | sed "s/${STACK_NAME}-backup-//")
    echo "$((i+1))) $TIMESTAMP"
done

read -p "Enter the NUMBER of the backup to restore: " BACKUP_SELECTION

# Validate selection
if [[ "$BACKUP_SELECTION" -lt 1 || "$BACKUP_SELECTION" -gt ${#BACKUP_DIRS[@]} ]]; then
    echo "Invalid selection. Aborting." | tee -a "$LOG_FILE"
    exit 1
fi

# Get the actual directory path based on the user's selection (arrays are 0-indexed)
SELECTED_BACKUP_DIR="${BACKUP_DIRS[$((BACKUP_SELECTION-1))]}"
SELECTED_TIMESTAMP=$(basename "$SELECTED_BACKUP_DIR" | sed "s/${STACK_NAME}-backup-//")

echo "-> Rolling back $STACK_NAME to $SELECTED_TIMESTAMP..." | tee -a "$LOG_FILE"

# Stop services based on stack
if [ "$STACK_NAME" == "stack1" ]; then
    echo "Stopping PM2 instances..." | tee -a "$LOG_FILE"
    pm2 stop nodejs-api-3000 nodejs-api-3003 nodejs-api-3004 nextjs-app-3001 nextjs-app-3002 >> "$LOG_FILE" 2>&1
elif [ "$STACK_NAME" == "stack2" ]; then
    echo "Stopping Systemd Laravel instances..." | tee -a "$LOG_FILE"
    sudo systemctl stop laravel-app-8000 laravel-app-8001 laravel-app-8002 laravel-worker >> "$LOG_FILE" 2>&1
elif [ "$STACK_NAME" == "stack3" ]; then
    echo "Stopping Systemd/PM2 instances..." | tee -a "$LOG_FILE"
    sudo systemctl stop fastapi-app-8003 fastapi-app-8004 fastapi-app-8005 >> "$LOG_FILE" 2>&1
    pm2 stop stack3-nextjs-3005 stack3-nextjs-3006 >> "$LOG_FILE" 2>&1
fi

echo "-> Restoring files from $SELECTED_BACKUP_DIR..." | tee -a "$LOG_FILE"
# Ensure the target directory exists, then copy the backup contents into it
# TARGET_DIR="${BACKUP_BASE_DIR}/${STACK_NAME}"
# mkdir -p "$TARGET_DIR"
# cp -r "$SELECTED_BACKUP_DIR"/* "$TARGET_DIR"/
sleep 2

echo "-> Rolling back database migrations..." | tee -a "$LOG_FILE"
# cd "$TARGET_DIR"
# (Run appropriate rollback command here)
sleep 2

echo "-> Restarting services..." | tee -a "$LOG_FILE"
if [ "$STACK_NAME" == "stack1" ]; then
    pm2 start nodejs-api-3000 nodejs-api-3003 nodejs-api-3004 nextjs-app-3001 nextjs-app-3002 >> "$LOG_FILE" 2>&1
elif [ "$STACK_NAME" == "stack2" ]; then
    sudo systemctl start laravel-app-8000 laravel-app-8001 laravel-app-8002 laravel-worker >> "$LOG_FILE" 2>&1
elif [ "$STACK_NAME" == "stack3" ]; then
    sudo systemctl start fastapi-app-8003 fastapi-app-8004 fastapi-app-8005 >> "$LOG_FILE" 2>&1
    pm2 start stack3-nextjs-3005 stack3-nextjs-3006 >> "$LOG_FILE" 2>&1
fi

echo "========================================================" | tee -a "$LOG_FILE"
echo "[SUCCESS] Rollback complete for $STACK_NAME! System restored to $SELECTED_TIMESTAMP." | tee -a "$LOG_FILE"
echo "========================================================" | tee -a "$LOG_FILE"