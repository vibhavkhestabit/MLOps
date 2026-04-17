#!/bin/bash

# Script: firewall_audit.sh
# Description: Audits UFW firewall rules for security best practices.
# Author: Vibhav Khaneja

REPORT_DIR="reports"
mkdir -p "$REPORT_DIR"
REPORT_FILE="${REPORT_DIR}/firewall_audit_$(date +%Y%m%d).txt"

SCORE=100
ISSUES=0

# Helper function to log issues and deduct points
add_issue() {
    local level=$1
    local msg=$2
    local penalty=$3
    
    echo "[$level] $msg" | tee -a "$REPORT_FILE"
    ISSUES=$((ISSUES + 1))
    SCORE=$((SCORE - penalty))
}

echo "========== FIREWALL AUDIT ==========" | tee "$REPORT_FILE"
echo "Date: $(date)" | tee -a "$REPORT_FILE"
echo "------------------------------------" | tee -a "$REPORT_FILE"

# 1. Check if UFW is active
UFW_STATUS=$(sudo ufw status | grep -i "Status: active")
if [ -z "$UFW_STATUS" ]; then
    echo "Status: INACTIVE" | tee -a "$REPORT_FILE"
    add_issue "CRITICAL" "Firewall is completely disabled! Run 'sudo ufw enable'." 50
    echo "Security Score: $SCORE/100" | tee -a "$REPORT_FILE"
    echo "====================================" | tee -a "$REPORT_FILE"
    exit 1
else
    echo "Status: Active" | tee -a "$REPORT_FILE"
fi

# 2. Count Active Rules
RULE_COUNT=$(sudo ufw status numbered | grep -E "^\[ *[0-9]+\]" | wc -l)
echo "Rules Configured: $RULE_COUNT" | tee -a "$REPORT_FILE"
echo "------------------------------------" | tee -a "$REPORT_FILE"
echo "Findings:" | tee -a "$REPORT_FILE"

# 3. Security Checks (Grab the raw rule data)
UFW_EXPORT=$(sudo ufw status)

# A. SSH Rate Limiting Check
if echo "$UFW_EXPORT" | grep -E "^22/tcp.*ALLOW" > /dev/null; then
    add_issue "CRITICAL" "SSH port 22 has no rate limiting (Current: ALLOW, Recommended: LIMIT)." 20
elif ! echo "$UFW_EXPORT" | grep -E "^22/tcp.*LIMIT" > /dev/null; then
    add_issue "WARNING" "SSH port 22 is completely closed or missing." 10
else
    echo "[PASS] SSH port 22 is properly rate-limited." | tee -a "$REPORT_FILE"
fi

# B. Database Exposure Check (Port 3306)
if echo "$UFW_EXPORT" | grep -E "^3306.*Anywhere" > /dev/null; then
    add_issue "CRITICAL" "MySQL Port 3306 is open to the entire internet! Restrict to local IPs." 30
else
    echo "[PASS] MySQL port 3306 is not globally exposed." | tee -a "$REPORT_FILE"
fi

# C. Dangerous Legacy Ports (FTP:21, Telnet:23)
if echo "$UFW_EXPORT" | grep -E "^21/tcp.*ALLOW" > /dev/null; then
    add_issue "CRITICAL" "FTP (Port 21) is open. This is unencrypted and highly insecure." 20
fi
if echo "$UFW_EXPORT" | grep -E "^23/tcp.*ALLOW" > /dev/null; then
    add_issue "CRITICAL" "Telnet (Port 23) is open. This is unencrypted and highly insecure." 20
fi

# D. Best Practice Warnings
echo "[INFO] Consider moving SSH from default Port 22 to a non-standard port (e.g., 2222) to avoid automated bots." | tee -a "$REPORT_FILE"

# 4. Final Math & Output
if [ "$SCORE" -lt 0 ]; then SCORE=0; fi # Prevent negative scores

echo "------------------------------------" | tee -a "$REPORT_FILE"
echo "Issues Found: $ISSUES" | tee -a "$REPORT_FILE"
echo "Security Score: $SCORE/100" | tee -a "$REPORT_FILE"
echo "====================================" | tee -a "$REPORT_FILE"
echo "Audit complete. Report saved to $REPORT_FILE"