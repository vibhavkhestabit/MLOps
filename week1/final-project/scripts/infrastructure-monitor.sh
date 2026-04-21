#!/bin/bash
set -euo pipefail

# Script: infrastructure-monitor.sh
# Description: Unified dashboard and monitoring trigger for the MLOps server.
# Author: Vibhav Khaneja
# Date: $(date +%Y-%m-%d)
# Usage: ./infrastructure-monitor.sh [options]

readonly EXIT_SUCCESS=0
readonly EXIT_ERROR=1

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="/var/log/apps/$(basename $0 .sh).log"
PREV_DIR="/home/vibhavkhaneja/MLOps-Training/week1/day5"

log_info() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $1" | tee -a "$LOG_FILE"; }
log_error() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $1" | tee -a "$LOG_FILE" >&2; }

show_usage() {
cat << EOF
Usage: $(basename $0) [OPTIONS]
Description: Unified dashboard and monitoring trigger for the MLOps server.
OPTIONS:
    -h, --help      Show this help message
    -d, --dashboard Generate a combined health dashboard
    -r, --report    Trigger the daily syshealth report manually
EOF
}

main() {
    log_info "Triggering Infrastructure Monitor..."
    bash "$PREV_DIR/monitor.sh" || log_error "Real-time monitor failed"
    log_info "Monitor check complete."
}

generate_dashboard() {
    echo "==================================================="
    echo "       LIVE INFRASTRUCTURE DASHBOARD"
    echo "==================================================="
    echo "CPU & MEMORY LOAD:"
    top -bn1 | head -n 5
    echo "---------------------------------------------------"
    echo "RECENT ALERTS:"
    tail -n 5 /var/log/apps/alerts.log 2>/dev/null || echo "No recent alerts."
    echo "==================================================="
}

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help) show_usage; exit $EXIT_SUCCESS ;;
        -d|--dashboard) generate_dashboard; exit $EXIT_SUCCESS ;;
        -r|--report) bash "$PREV_DIR/syshealth-report.sh"; exit $EXIT_SUCCESS ;;
        *) echo "Unknown option: $1"; show_usage; exit $EXIT_ERROR ;;
    esac
    shift
done

main "$@"