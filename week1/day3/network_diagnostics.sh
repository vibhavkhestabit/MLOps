#!/bin/bash
set -euo pipefail

# Script: network_diagnostics.sh
# Description: Automated network health and connectivity check.
# Author: Vibhav Khaneja
# Date: 2026-04-16
# Usage:./network_diagnostics.sh

LOG_DIR="logs"
LOG_FILE="${LOG_DIR}/network_diag_$(date +%Y%m%d).log"

echo "Starting Network Diagnostics Engine..."
echo "==========================================" > "$LOG_FILE"
echo "       NETWORK DIAGNOSTICS REPORT         " >> "$LOG_FILE"
echo " Date: $(date '+%Y-%m-%d %H:%M:%S')" >> "$LOG_FILE"
echo "==========================================" >> "$LOG_FILE"

# Helper functions for color-coded terminal output + file logging
log_pass() { echo -e "[\e[32mPASS\e[0m] $1" | tee -a "$LOG_FILE"; }
log_fail() { echo -e "[\e[31mFAIL\e[0m] $1" | tee -a "$LOG_FILE"; }
log_warn() { echo -e "[\e[33mWARN\e[0m] $1" | tee -a "$LOG_FILE"; }
log_info() { echo -e "\n--- $1 ---" >> "$LOG_FILE"; }

echo ""

# 1. Internet Connectivity (Ping Google's DNS)
# -c 3 means "send exactly 3 pings"
if ping -c 3 8.8.8.8 >/dev/null 2>&1; then
    log_pass "Internet connectivity (8.8.8.8): OK"
else
    log_fail "Internet connectivity (8.8.8.8): Unreachable"
fi

# 2. DNS Resolution
# Save the output of dig directly into a variable named RESOLVED_IP
RESOLVED_IP=$(dig +short google.com | tail -n1)

# Check if the variable is NOT empty (-n)
if [ -n "$RESOLVED_IP" ]; then
    log_pass "DNS resolution (google.com): OK -> IP is $RESOLVED_IP"
else
    log_fail "DNS resolution (google.com): Failed"
fi

# 3. Port Testing (Testing if the local SSH door is open)
# -z (zero I/O mode, just scan), -v (verbose)
if nc -zv 127.0.0.1 22 >/dev/null 2>&1; then
    log_pass "Port 22 (SSH) on localhost: Open"
else
    log_fail "Port 22 (SSH) on localhost: Connection refused"
fi

# 4. Latency Check
# We ping Google, grab the bottom line, extract the 4th column, and slice out the average time
LATENCY=$(ping -c 3 8.8.8.8 | tail -1 | awk '{print $4}' | cut -d '/' -f 2)

if [ -n "$LATENCY" ]; then
    # We use awk to do math with decimals. If latency is over 100ms, throw a warning!
    if awk "BEGIN {exit !($LATENCY > 100)}"; then
        log_warn "High latency to 8.8.8.8: ${LATENCY}ms"
    else
        log_pass "Latency to 8.8.8.8: ${LATENCY}ms (Good)"
    fi
fi

# 5. Network Interfaces & IPs (Brief format)
log_info "NETWORK INTERFACES"
ip -br addr >> "$LOG_FILE"

# 6. Routing Table
log_info "ROUTING TABLE"
ip route >> "$LOG_FILE"

# 7. Open Ports
log_info "OPEN PORTS"
ss -tuln >> "$LOG_FILE"

echo ""
echo "=========================================="
echo "Diagnostics complete. Full report saved to: $LOG_FILE"