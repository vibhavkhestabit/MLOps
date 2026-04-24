#!/bin/bash

# Script: ssl_renewal_automation.sh
# Description: Automates Let's Encrypt certificate renewal and self-installs into cron.
# Author: Vibhav Khaneja
# Date: 2026-04-24

LOG_FILE="/var/log/ssl_renewal.log"

# --- SELF-INSTALLATION BLOCK ---
# Get the absolute path of this script, no matter where it is executed from
SCRIPT_PATH=$(readlink -f "$0")
CRON_JOB="0 3 * * 1 $SCRIPT_PATH"

# Check if the cron job already exists in the root crontab
if ! sudo crontab -l 2>/dev/null | grep -q "$SCRIPT_PATH"; then
    echo "First run detected! Automatically installing cron job..."
    # Dump the current crontab, append our new job, and load it back in
    (sudo crontab -l 2>/dev/null; echo "$CRON_JOB") | sudo crontab -
    echo "✓ Cron job successfully installed to run every Monday at 3:00 AM."
fi
# -------------------------------

echo "[$(date '+%Y-%m-%d %H:%M:%S')] Starting automated SSL renewal process..." >> "$LOG_FILE"

if ! command -v certbot >/dev/null 2>&1; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Certbot not installed. Skipping Let's Encrypt renewal." >> "$LOG_FILE"
    exit 0
fi

if sudo certbot renew --quiet; then
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] Certificates renewed successfully (or not yet due)." >> "$LOG_FILE"
    if sudo nginx -t >/dev/null 2>&1; then
        sudo systemctl reload nginx
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] Nginx reloaded to apply new certificates." >> "$LOG_FILE"
    else
        echo "[$(date '+%Y-%m-%d %H:%M:%S')] CRITICAL ERROR: Nginx config invalid, skipping reload." >> "$LOG_FILE"
    fi
else
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] ERROR: Certbot renewal failed." >> "$LOG_FILE"
fi