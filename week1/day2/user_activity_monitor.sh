#!/bin/bash
set -euo pipefail

# Script: user_activity_monitor.sh
# Description: Generates a security report on user logins and command history.
# Author: Vibhav Khaneja
# Date: 2026-04-15
# Usage: sudo ./user_activity_monitor.sh

REPORT_FILE="user_activity_report.txt"

echo "Generating User Activity Report..."

# Initialize the report
echo "==========================================" > "$REPORT_FILE"
echo "         USER ACTIVITY REPORT             " >> "$REPORT_FILE"
echo " Date: $(date '+%Y-%m-%d %H:%M:%S')" >> "$REPORT_FILE"
echo "==========================================" >> "$REPORT_FILE"

# 1. Currently Logged-In Users
echo -e "\n[1] CURRENTLY LOGGED-IN USERS (w command)" >> "$REPORT_FILE"
echo "------------------------------------------" >> "$REPORT_FILE"
w >> "$REPORT_FILE"

# 2. Recent Logins
echo -e "\n[2] LAST 5 LOGINS TO THE SERVER (last command)" >> "$REPORT_FILE"
echo "------------------------------------------" >> "$REPORT_FILE"
last -n 5 >> "$REPORT_FILE"

# 3. User Command History (Checking .bash_history)
echo -e "\n[3] RECENT COMMAND HISTORY BY USER" >> "$REPORT_FILE"
echo "------------------------------------------" >> "$REPORT_FILE"
# Loop through every folder in /home
for user_dir in /home/*; do
    if [ -d "$user_dir" ]; then
        username=$(basename "$user_dir")
        hist_file="$user_dir/.bash_history"
        
        echo ">>> User: $username" >> "$REPORT_FILE"
        
        # Check if the history file exists and has text in it
        if [ -s "$hist_file" ]; then
            # Grab the last 5 commands they typed
            tail -n 5 "$hist_file" >> "$REPORT_FILE"
        else
            echo "  (No command history found)" >> "$REPORT_FILE"
        fi
        echo "" >> "$REPORT_FILE"
    fi
done

# 4. Inactive Users (> 90 Days)
echo -e "\n[4] INACTIVE ACCOUNTS (> 90 Days)" >> "$REPORT_FILE"
echo "------------------------------------------" >> "$REPORT_FILE"
# lastlog -b 90 looks for logins older than 90 days. 
# We use grep -v to filter out background system accounts that say "Never logged in"
lastlog -b 90 | grep -v "Never logged in" >> "$REPORT_FILE"

echo "==========================================" >> "$REPORT_FILE"
echo "Report successfully saved to: $REPORT_FILE"