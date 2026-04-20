#!/bin/bash
set -euo pipefail

# Configuration
REPORT_DIR="/var/log/apps/reports"
REPORT_FILE="${REPORT_DIR}/health-$(date +%Y-%m-%d).txt"

# Create the reports directory if it doesn't exist
mkdir -p "$REPORT_DIR"

# Generate report (Everything between the {} gets dumped into the text file)
{
    echo "==========================================="
    echo "          SYSTEM HEALTH REPORT"
    echo " Generated: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "==========================================="
    echo ""
    
    echo "--- SYSTEM INFORMATION ---"
    echo "Hostname: $(hostname)"
    echo "OS: $(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2)"
    echo "Kernel: $(uname -r)"
    echo "Uptime: $(uptime -p)"
    echo ""
    
    echo "--- DISK USAGE ---"
    df -h | grep -vE '^Filesystem|tmpfs|cdrom|loop'
    echo ""
    
    echo "--- MEMORY USAGE ---"
    free -h
    echo ""
    
    echo "--- CPU LOAD ---"
    uptime
    echo ""
    
    echo "--- TOP PROCESSES (CPU) ---"
    ps aux --sort=-%cpu | head -6
    echo ""
    
    echo "--- TOP PROCESSES (MEMORY) ---"
    ps aux --sort=-%mem | head -6
    echo ""
    
    echo "--- NETWORK INTERFACES ---"
    ip -br addr
    echo ""
    
    echo "--- ACTIVE CONNECTIONS ---"
    echo "Total connections: $(ss -tuln | wc -l)"
    echo ""
    
    echo "--- RECENT ERRORS (Last 50) ---"
    tail -50 /var/log/apps/errors.log 2>/dev/null || echo "No error log found"
    echo ""
    
    echo "--- SERVICE STATUS ---"
    systemctl is-active ssh && echo "SSH: Active" || echo "SSH: Inactive"
    systemctl is-active cron && echo "Cron: Active" || echo "Cron: Inactive"
    echo ""
    
    echo "==========================================="
    echo "             END OF REPORT"
    echo "==========================================="

} > "$REPORT_FILE"

echo "Success: Report generated at $REPORT_FILE"