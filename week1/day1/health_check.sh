#!/bin/bash
set -euo pipefail

# Script: health_check.sh
# Description: Performs system health checks (services, disk, mem, network).
# Author: Vibhav Khaneja
# Date: 2026-04-14
# Usage: ./health_check.sh

# Exit codes
readonly EXIT_SUCCESS=0
readonly EXIT_ERROR=1

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="${SCRIPT_DIR}/logs"
LOG_FILE="${LOG_DIR}/health_check.log"

# Thresholds (from syllabus)
readonly DISK_THRESHOLD=90
readonly MEM_THRESHOLD=85
readonly PING_TARGET="8.8.8.8"

mkdir -p "$LOG_DIR"

# Logging functions
log_info() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $1" | tee -a "$LOG_FILE"; }
log_error() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $1" | tee -a "$LOG_FILE" >&2; }

# Helper function to print colored PASS/FAIL
print_result() {
    local status=$1
    local message=$2
    if [[ "$status" == "PASS" ]]; then
        echo -e "[\033[32mPASS\033[0m] $message"
    else
        echo -e "[\033[31mFAIL\033[0m] $message"
    fi
}

main() {
    log_info "Starting system health check..."
    echo "======================================"
    echo "         SYSTEM HEALTH CHECK          "
    echo "======================================"

    local final_status=0 # Assume healthy (0) until proven otherwise

    # 1. Check Critical Services (ssh, cron)
    for service in ssh cron; do
        # systemctl is-active returns 0 if running, non-zero if not
        if systemctl is-active --quiet "$service"; then
            print_result "PASS" "Service '$service' is running"
        else
            print_result "FAIL" "Service '$service' is NOT running"
            final_status=1
            log_error "Service '$service' is down."
        fi
    done

    # 2. Check Disk Space (Below 90%)
    # Extract the percentage number only for the root partition
    local disk_usage=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
    if [[ "$disk_usage" -lt "$DISK_THRESHOLD" ]]; then
        print_result "PASS" "Disk usage is ${disk_usage}% (Threshold: ${DISK_THRESHOLD}%)"
    else
        print_result "FAIL" "Disk usage is ${disk_usage}% (CRITICAL: > ${DISK_THRESHOLD}%)"
        final_status=1
        log_error "Disk usage exceeded threshold."
    fi

    # 3. Check Memory Usage (Below 85%)
    # Calculate percentage as an integer
    local mem_usage=$(free | awk '/^Mem:/ {printf "%.0f", $3/$2 * 100}')
    if [[ "$mem_usage" -lt "$MEM_THRESHOLD" ]]; then
        print_result "PASS" "Memory usage is ${mem_usage}% (Threshold: ${MEM_THRESHOLD}%)"
    else
        print_result "FAIL" "Memory usage is ${mem_usage}% (CRITICAL: > ${MEM_THRESHOLD}%)"
        final_status=1
        log_error "Memory usage exceeded threshold."
    fi

    # 4. Check Network Connectivity
    # ping -c 1 sends exactly one packet. -W 2 sets a 2-second timeout.
    if ping -c 1 -W 2 "$PING_TARGET" >/dev/null 2>&1; then
        print_result "PASS" "Network connectivity to $PING_TARGET OK"
    else
        print_result "FAIL" "Network connectivity to $PING_TARGET FAILED"
        final_status=1
        log_error "Network ping failed."
    fi

    echo "======================================"
    
    if [[ $final_status -eq 0 ]]; then
        log_info "Health check passed. System is HEALTHY."
    else
        log_error "Health check failed. System is UNHEALTHY."
    fi

    # Exit with the final calculated status (0 or 1)
    exit $final_status
}

main "$@"