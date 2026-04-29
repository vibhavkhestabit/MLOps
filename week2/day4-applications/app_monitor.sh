#!/bin/bash
set -euo pipefail

# Script: app_monitor.sh
# Description: Enterprise watchdog for PM2 and Systemd applications.
# Author: Vibhav Khaneja

readonly EXIT_SUCCESS=0
readonly EXIT_ERROR=1
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly LOG_DIR="${SCRIPT_DIR}/logs"
readonly LOG_FILE="${LOG_DIR}/app_monitor_$(date +%Y-%m-%d).log"

mkdir -p "$LOG_DIR"

# Standardized Logging
log_info() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $1" | tee -a "$LOG_FILE"; }
log_error() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $1" | tee -a "$LOG_FILE" >&2; }

print_result() {
    local status=$1
    local message=$2
    if [[ "$status" == "PASS" ]]; then
        echo -e "  [\033[32mPASS\033[0m] $message"
    else
        echo -e "  [\033[31mFAIL\033[0m] $message"
    fi
}

check_pm2() {
    local app_name=$1
    local port=$2
    local is_healthy=0
    
    log_info "Checking PM2 App: $app_name (Port $port)"
    
    if pm2 status "$app_name" | grep -q "online"; then
        print_result "PASS" "PM2 Status: online"
    else
        print_result "FAIL" "PM2 Status: OFFLINE"
        is_healthy=1
    fi

    if curl -s -f -m 2 "http://localhost:$port/api/health" > /dev/null || curl -s -f -m 2 "http://localhost:$port" > /dev/null; then
        print_result "PASS" "Health Check: OK"
    else
        print_result "FAIL" "Health Check: FAILED"
        is_healthy=1
    fi
    
    return $is_healthy
}

check_systemd() {
    local service_name=$1
    local port=$2
    local is_healthy=0
    
    log_info "Checking Systemd Service: $service_name (Port $port)"
    
    if systemctl is-active --quiet "$service_name"; then
        print_result "PASS" "Systemd Status: active (running)"
    else
        print_result "FAIL" "Systemd Status: INACTIVE/FAILED"
        is_healthy=1
    fi

    if curl -s -f -m 2 "http://localhost:$port" > /dev/null || curl -s -f -m 2 "http://localhost:$port/api/health" > /dev/null; then
         print_result "PASS" "Network/Port: OK"
    else
         print_result "FAIL" "Network/Port: UNREACHABLE"
         is_healthy=1
    fi
    
    return $is_healthy
}

main() {
    log_info "Starting Application Monitoring Report..."
    echo "======================================"
    
    local final_status=0

    # The '|| final_status=1' catches the error so 'set -e' doesn't kill the script
    check_pm2 "express-api" 3000 || final_status=1
    echo "--------------------------------------"
    check_pm2 "nextjs-app" 3001 || final_status=1
    echo "--------------------------------------"
    check_systemd "fastapi" 8000 || final_status=1
    echo "--------------------------------------"
    check_systemd "laravel-app" 9000 || final_status=1
    
    echo "======================================"
    if [[ $final_status -eq 0 ]]; then
        log_info "All applications are HEALTHY."
    else
        log_error "ALERT: One or more applications are UNHEALTHY or OFFLINE."
    fi

    exit $final_status
}

main "$@"