#!/bin/bash
set -euo pipefail

# Script: process_monitor.sh
# Description: Displays top processes by CPU/Mem, auto-updates, and allows PID killing.
# Author: Vibhav Khaneja
# Date: 2026-04-14
# Usage: ./process_monitor.sh

# Exit codes
readonly EXIT_SUCCESS=0
readonly EXIT_ERROR=1

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="${SCRIPT_DIR}/logs"
LOG_FILE="${LOG_DIR}/script_execution.log"
SNAPSHOT_FILE="${LOG_DIR}/process.log" 

mkdir -p "$LOG_DIR"

# Logging functions
log_info() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $1" | tee -a "$LOG_FILE"; }
log_error() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $1" | tee -a "$LOG_FILE" >&2; }

show_usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Monitors top 10 CPU and Memory consuming processes. Updates every 5 seconds.

OPTIONS:
    -h, --help      Show this help message
EOF
}

take_snapshot() {
    local timestamp=$(date '+%Y-%m-%d %H:%M:%S')
    echo "--- Snapshot at $timestamp ---" >> "$SNAPSHOT_FILE"
    ps aux --sort=-%cpu | head -n 11 >> "$SNAPSHOT_FILE"
    echo "" >> "$SNAPSHOT_FILE"
}

main() {
    log_info "Starting live process monitor..."

    # Infinite loop for the live dashboard
    while true; do
        clear
        echo "=================================================================="
        echo "                      LIVE PROCESS MONITOR                        "
        echo "=================================================================="
        
        # Total Process Count
        local total_procs=$(ps -e | wc -l)
        echo "Total Running Processes: $total_procs"
        echo "------------------------------------------------------------------"
        
        # Top 10 by CPU (ps aux sorted by -%cpu, piped to awk for clean formatting)
        echo " TOP 10 PROCESSES BY CPU USAGE:"
        ps aux --sort=-%cpu | awk 'NR==1 || NR<=11 {printf "%-8s %-12s %-6s %-6s %s\n", $2, $1, $3"%", $4"%", $11}'
        echo "------------------------------------------------------------------"
        
        # Top 10 by Memory (ps aux sorted by -%mem)
        echo " TOP 10 PROCESSES BY MEMORY USAGE:"
        ps aux --sort=-%mem | awk 'NR==1 || NR<=11 {printf "%-8s %-12s %-6s %-6s %s\n", $2, $1, $3"%", $4"%", $11}'
        echo "=================================================================="
        
        # Save the snapshot to logs as required
        take_snapshot

        # Interactive Controls
        echo -e "\nControls:"
        echo " - Wait 5 seconds for auto-refresh"
        echo " - Press [Enter] to refresh immediately"
        echo " - Type a PID and press [Enter] to KILL a process"
        echo " - Press [Ctrl+C] to exit"
        
        local target_pid=""
        
        # Disable 'set -e' temporarily so the 5s timeout doesn't crash the script
        set +e
        read -t 5 -p "Enter PID to kill (or wait): " target_pid
        set -e

        # If the user typed something, attempt to kill it
        if [[ -n "$target_pid" ]]; then
            if [[ "$target_pid" =~ ^[0-9]+$ ]]; then
                log_info "Attempting to kill PID: $target_pid"
                # 2>/dev/null hides standard error messages from the kill command
                if kill -9 "$target_pid" 2>/dev/null; then
                    echo " Successfully killed PID $target_pid"
                else
                    echo " Failed to kill PID $target_pid (You might need sudo, or it doesn't exist)"
                fi
                sleep 2 # Pause for 2 seconds so the user can read the success/fail message
            else
                echo " Invalid input. Please enter numbers only for a PID."
                sleep 2
            fi
        fi
    done
}

# Parse arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help) show_usage; exit $EXIT_SUCCESS ;;
        *) echo "Unknown option: $1"; show_usage; exit $EXIT_ERROR ;;
    esac
    shift
done

main "$@"