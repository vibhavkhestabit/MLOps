#!/bin/bash
set -euo pipefail

# Configuration
LOG_DIR="/var/log/apps"
LOG_FILE="${LOG_DIR}/monitor.log"
ALERT_LOG="${LOG_DIR}/alerts.log"

# Thresholds
DISK_THRESHOLD=80
MEM_THRESHOLD=80
CPU_THRESHOLD=80

# Logging functions
log_info() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $1" | tee -a "$LOG_FILE"
}

log_error() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $1" | tee -a "$LOG_FILE" >&2
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ALERT] $1" >> "$ALERT_LOG"
}

log_warn() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [WARN] $1" | tee -a "$LOG_FILE"
}

# Check disk usage
check_disk() {
    log_info "Checking disk usage..."
    while IFS= read -r line; do
        usage=$(echo "$line" | awk '{print $5}' | sed 's/%//')
        mount=$(echo "$line" | awk '{print $6}')

        if [[ $usage -gt $DISK_THRESHOLD ]]; then
            log_error "Disk usage HIGH: ${mount} is at ${usage}% (threshold: ${DISK_THRESHOLD}%)"
            return 1
        fi
    done < <(df -h | grep -vE '^Filesystem|tmpfs|cdrom|loop')

    log_info "Disk usage: OK"
    return 0
}

# Check memory usage
check_memory() {
    log_info "Checking memory usage..."
    mem_usage=$(free | grep Mem | awk '{printf "%.0f", ($3/$2) * 100}')

    if [[ $mem_usage -gt $MEM_THRESHOLD ]]; then
        log_error "Memory usage HIGH: ${mem_usage}% (threshold: ${MEM_THRESHOLD}%)"
        return 1
    fi

    log_info "Memory usage: ${mem_usage}% - OK"
    return 0
}

# Check CPU usage
check_cpu() {
    log_info "Checking CPU usage..."
    cpu_usage=$(top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1 | cut -d'.' -f1)

    if [[ $cpu_usage -gt $CPU_THRESHOLD ]]; then
        log_error "CPU usage HIGH: ${cpu_usage}% (threshold: ${CPU_THRESHOLD}%)"
        return 1
    fi

    log_info "CPU usage: ${cpu_usage}% - OK"
    return 0
}

# Main execution
main() {
    log_info "========== System Health Check Started =========="

    status=0
    check_disk || status=1
    check_memory || status=1
    check_cpu || status=1

    if [[ $status -eq 0 ]]; then
        log_info "All checks passed successfully"
    else
        log_error "Some checks failed. Review alerts."
    fi

    log_info "========== System Health Check Completed =========="
    exit $status
}

main