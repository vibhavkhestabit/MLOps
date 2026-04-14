#!/bin/bash
set -euo pipefail

# Script: system_inventory.sh
# Description: Undertstanding System Informationa and Architecture: Gathers CPU, memory, disk, OS info, and network details.
# Author: Vibhav Khaneja
# Date: 2026-04-14
# Usage: ./system_inventory.sh

# Exit codes
readonly EXIT_SUCCESS=0
readonly EXIT_ERROR=1

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Using local directory for logs to avoid permission issues during early training
LOG_DIR="${SCRIPT_DIR}/logs"
LOG_FILE="${LOG_DIR}/system_inventory.log"

mkdir -p "$LOG_DIR"

# Logging functions
log_info() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $1" | tee -a "$LOG_FILE"; }
log_error() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $1" | tee -a "$LOG_FILE" >&2; }

# Help function
show_usage() {
    cat << EOF
Usage: $(basename "$0") [OPTIONS]

Gathers comprehensive system information and outputs a formatted table.

OPTIONS:
    -h, --help      Show this help message
EOF
}

# Main function
main() {
    log_info "Starting system inventory scan..."

    # Gather Data
    local hostname=$(hostname)
    local os=$(grep PRETTY_NAME /etc/os-release | cut -d'"' -f2)
    local kernel=$(uname -r)
    local uptime=$(uptime -p | sed 's/up //')
    local cpu_model=$(lscpu | grep "Model name:" | sed -r 's/Model name:\s+//g')
    local cpu_cores=$(nproc)
    
    # Calculate Memory (awk extracts total and calculates percentage used)
    local mem_info=$(free -m | awk '/^Mem:/ {printf "%.2fGB (%.0f%% used)", $2/1024, $3/$2 * 100}')
    
    # Calculate Disk (gets the root partition usage)
    local disk_info=$(df -h / | awk 'NR==2 {print $2 " ("$5" used)"}')
    
    # Network Interfaces
    local network_ips=$(ip -4 addr show | grep inet | awk '{print $NF ": " $2}' | paste -sd ", ")
    
    # Software Count (Assuming Debian/Ubuntu based on apt usage in syllabus)
    local software_count=$(dpkg-query -f '.\n' -W | wc -l)

    # Output Table
    echo ""
    echo "========== SYSTEM INVENTORY =========="
    echo "Hostname:   $hostname"
    echo "OS:         $os"
    echo "Kernel:     $kernel"
    echo "Uptime:     $uptime"
    echo "CPU:        $cpu_model ($cpu_cores cores)"
    echo "Memory:     $mem_info"
    echo "Disk (/):   $disk_info"
    echo "Network:    $network_ips"
    echo "Packages:   $software_count installed"
    echo "======================================"
    echo ""

    log_info "System inventory scan completed successfully."
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