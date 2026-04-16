#!/bin/bash

# Script: dns_monitor.sh
# Description: Actively interrogates local DNS to ensure records match hosts.csv and response times are healthy.
# Author: Vibhav Khaneja

LOG_DIR="logs"
mkdir -p "$LOG_DIR"
# We log by month/day so the file doesn't get too massive over a year
LOG_FILE="${LOG_DIR}/dns_monitor_$(date +%Y%m).log"

CSV_FILE="hosts.csv"
DNS_SERVER="127.0.0.1"
DOMAIN="devops.lab"

echo "==========================================" >> "$LOG_FILE"
echo "DNS Surveillance Run: $(date '+%Y-%m-%d %H:%M:%S')" >> "$LOG_FILE"
echo "==========================================" >> "$LOG_FILE"

echo "Starting Active DNS Surveillance..."

# Helper function to print colors to the screen AND save plain text to the log
log_msg() {
    local type=$1
    local msg=$2
    if [ "$type" == "PASS" ]; then
        echo -e "[\e[32mPASS\e[0m] $msg" | tee -a "$LOG_FILE"
    elif [ "$type" == "FAIL" ]; then
        echo -e "[\e[31mFAIL\e[0m] $msg" | tee -a "$LOG_FILE"
    elif [ "$type" == "WARN" ]; then
        echo -e "[\e[33mWARN\e[0m] $msg" | tee -a "$LOG_FILE"
    fi
}

# 1. Pre-Flight Check
if [ ! -f "$CSV_FILE" ]; then
    log_msg "FAIL" "Cannot find $CSV_FILE. Surveillance aborted."
    exit 1
fi

# 2. Interrogation Loop (Read the CSV, test the network)
tail -n +2 "$CSV_FILE" | while IFS=, read -r hostname ip type alias; do
    
    # Strip carriage returns to prevent string comparison bugs
    hostname=$(echo "$hostname" | tr -d '\r')
    ip=$(echo "$ip" | tr -d '\r')
    
    FULL_NAME="${hostname}.${DOMAIN}"
    echo "-> Auditing Node: $FULL_NAME" >> "$LOG_FILE"

    # --- TEST A: Forward Resolution ---
    FWD_RESULT=$(dig @"$DNS_SERVER" "$FULL_NAME" +short | tail -n1)
    
    if [ "$FWD_RESULT" == "$ip" ]; then
        log_msg "PASS" "Forward Record: $FULL_NAME -> $ip"
    else
        log_msg "FAIL" "Forward Record: $FULL_NAME returned '$FWD_RESULT' (Expected: $ip)"
    fi

    # --- TEST B: Reverse Resolution ---
    # Note: Reverse DNS results from 'dig' always end with a trailing period (e.g., web-01.devops.lab.)
    REV_RESULT=$(dig @"$DNS_SERVER" -x "$ip" +short | tail -n1)
    
    if [ "$REV_RESULT" == "${FULL_NAME}." ]; then
        log_msg "PASS" "Reverse Record: $ip -> $FULL_NAME"
    else
        log_msg "FAIL" "Reverse Record: $ip returned '$REV_RESULT' (Expected: ${FULL_NAME}.)"
    fi

    # --- TEST C: Latency & Responsiveness ---
    # We run a full dig query and use grep/awk to extract just the number of milliseconds
    QUERY_TIME=$(dig @"$DNS_SERVER" "$FULL_NAME" | grep "Query time:" | awk '{print $4}')

    if [ -n "$QUERY_TIME" ]; then
        if [ "$QUERY_TIME" -gt 100 ]; then
            log_msg "WARN" "Latency Spike! $FULL_NAME took ${QUERY_TIME}ms to answer."
        else
            log_msg "PASS" "Latency Check: ${QUERY_TIME}ms"
        fi
    else
        log_msg "FAIL" "Server completely unresponsive to latency check."
    fi
    
    echo "------------------------------------------" >> "$LOG_FILE"

done

echo "Surveillance sweep complete. Full report stored in $LOG_FILE"