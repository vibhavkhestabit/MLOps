#!/bin/bash
set -euo pipefail

# Script: server-provision.sh
# Description: Master orchestrator to provision the complete MLOps infrastructure.
# Author: Vibhav Khaneja
# Date: $(date +%Y-%m-%d)
# Usage: sudo ./server-provision.sh

# Exit codes
readonly EXIT_SUCCESS=0
readonly EXIT_ERROR=1

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# Set logs to save in the final-project/logs directory
LOG_DIR="$SCRIPT_DIR/../logs"
LOG_FILE="$LOG_DIR/provision.log"
WEEK1_DIR="/home/vibhavkhaneja/MLOps-Training/week1"

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Logging functions (Added log_warn)
log_info() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $1" | tee -a "$LOG_FILE"; }
log_warn() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [WARN] $1" | tee -a "$LOG_FILE"; }
log_error() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $1" | tee -a "$LOG_FILE" >&2; }

show_usage() {
cat << EOF
Usage: $(basename $0) [OPTIONS]
Description: Master orchestrator to provision the complete MLOps infrastructure.
OPTIONS:
    -h, --help      Show this help message
EOF
}

main() {
    log_info "========== INFRASTRUCTURE PROVISIONING STARTED =========="

    # 1. System Inventory (Day 1)
    log_info "Step 1/7: Running System Inventory..."
    if [[ -f "$WEEK1_DIR/day1/system_inventory.sh" ]]; then
        bash "$WEEK1_DIR/day1/system_inventory.sh" || log_warn "Inventory script threw an error."
    else
        log_error "Could not find day1/system_inventory.sh"
    fi

    # 2. User Provisioning (Day 2)
    log_info "Step 2/7: Creating users with proper permissions..."
    if [[ -f "$WEEK1_DIR/day2/user_provision.sh" ]]; then
        bash "$WEEK1_DIR/day2/user_provision.sh" "$WEEK1_DIR/day2/users.txt" || log_warn "User provisioning issue."
    else
        log_error "Could not find day2/user_provision.sh"
    fi

    # 3. DNS Client Settings (Day 3)
    log_info "Step 3/7: Configuring DNS client settings..."
    echo "nameserver 127.0.0.1" > /etc/resolv.conf
    echo "search devops.lab" >> /etc/resolv.conf
    log_info "DNS client configured to local BIND9 server."

    # 4. Firewall Rules (Day 4)
    log_info "Step 4/7: Setting up UFW firewall rules..."
    ufw default deny incoming >/dev/null
    ufw default allow outgoing >/dev/null
    ufw allow 2222/tcp comment 'SSH Custom Port' >/dev/null
    ufw allow 80/tcp comment 'HTTP' >/dev/null
    ufw allow 443/tcp comment 'HTTPS' >/dev/null
    ufw --force enable >/dev/null
    log_info "UFW Firewall configured and enabled."

    # 5. Security Hardening (Day 4)
    log_info "Step 5/7: Implementing security hardening..."
    if [[ -f "$WEEK1_DIR/day4/security_hardening.sh" ]]; then
        bash "$WEEK1_DIR/day4/security_hardening.sh" || log_warn "Security hardening script issue."
    else
        log_error "Could not find day4/security_hardening.sh"
    fi

    # 6. LVM Storage (Day 5)
    log_info "Step 6/7: Checking LVM Storage configuration..."
    if mount | grep -q "/var/log/apps"; then
        log_info "LVM is already configured and mounted successfully."
    else
        log_warn "LVM mounts not detected! Manual setup required for persistent storage."
    fi

    # 7. Logging Infrastructure (Day 5)
    log_info "Step 7/7: Setting up logging infrastructure..."
    systemctl restart rsyslog
    log_info "rsyslog engine restarted with custom routing."

    log_info "========== INFRASTRUCTURE PROVISIONING COMPLETED =========="
}

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help) show_usage; exit $EXIT_SUCCESS ;;
        *) echo "Unknown option: $1"; show_usage; exit $EXIT_ERROR ;;
    esac
    shift
done

# Ensure script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (use sudo)" 
   exit 1
fi

main "$@"