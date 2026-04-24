#!/bin/bash
set -eo pipefail

# Script: nginx_setup.sh
# Description: Installs Nginx, optimizes core configs, and sets up default sites.
# Author: Vibhav Khaneja
# Date: 2026-04-24

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="${SCRIPT_DIR}/../logs"
LOG_FILE="${LOG_DIR}/nginx_setup.log"

mkdir -p "$LOG_DIR"

log_info() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $1" | tee -a "$LOG_FILE"; }
log_error() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $1" | tee -a "$LOG_FILE" >&2; }

main() {
    log_info "========== Nginx Setup =========="
    
    # 1. Install Nginx
    log_info "Installing latest Nginx..."
    sudo apt-get update
    sudo apt-get install -y nginx
    log_info "✓ Nginx installed"

    # 2. Optimize nginx.conf
    local NGINX_CONF="/etc/nginx/nginx.conf"
    log_info "Applying performance optimizations to $NGINX_CONF..."
    
    # Backup original
    sudo cp "$NGINX_CONF" "${SCRIPT_DIR}/../configs/nginx.conf.backup"

    # Set worker processes to auto (scales to CPU cores) and connections to 1024
    sudo sed -i 's/worker_processes.*/worker_processes auto;/' "$NGINX_CONF"
    sudo sed -i 's/worker_connections.*/worker_connections 1024;/' "$NGINX_CONF"
    
    # Enable Gzip compression if commented out
    sudo sed -i 's/# gzip on;/gzip on;/' "$NGINX_CONF"
    sudo sed -i 's/# gzip_types/gzip_types/' "$NGINX_CONF"

    log_info "✓ Configuration optimized"

    # 3. Directory Structure & Default Site
    log_info "Verifying directory structure..."
    sudo mkdir -p /etc/nginx/sites-available /etc/nginx/sites-enabled /var/www/html
    
    # Create a basic default index.html
    echo "<h1>Nginx is running successfully (Day 3 MLOps)</h1>" | sudo tee /var/www/html/index.html > /dev/null

    # 4. Service Management
    sudo systemctl enable nginx
    sudo systemctl restart nginx
    log_info "✓ Service started and enabled"

    # 5. Verification
    if curl -s http://localhost | grep -q "Nginx is running"; then
        log_info "✓ Test page accessible"
        log_info "Status: Ready"
    else
        log_error "Connection test FAILED."
        exit 1
    fi
    
    echo "================================="
}

main "$@"