#!/bin/bash
set -eo pipefail

# Script: apache_setup.sh
# Description: Installs Apache2, enables proxy/ssl modules, configures port 8080.
# Author: Vibhav Khaneja
# Date: 2026-04-24

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="${SCRIPT_DIR}/../logs"
LOG_FILE="${LOG_DIR}/apache_setup.log"

mkdir -p "$LOG_DIR"

log_info() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $1" | tee -a "$LOG_FILE"; }

main() {
    log_info "========== Apache Setup =========="
    
    # 1. Install Apache2
    log_info "Installing Apache2 (httpd)..."
    sudo apt-get update
    sudo apt-get install -y apache2
    log_info "✓ Apache2 installed"

    # 2. Enable Required Modules
    log_info "Enabling proxy, ssl, rewrite, and headers modules..."
    sudo a2enmod proxy proxy_http ssl rewrite headers mpm_event > /dev/null 2>&1 || true
    log_info "✓ Required modules enabled"

    # 3. Change Default Port to 8080 (to avoid conflict with Nginx)
    log_info "Configuring Apache to listen on port 8080..."
    sudo sed -i 's/Listen 80/Listen 8080/' /etc/apache2/ports.conf
    sudo sed -i 's/<VirtualHost \*:80>/<VirtualHost \*:8080>/' /etc/apache2/sites-available/000-default.conf

    # 4. Create Test Page
    echo "<h1>Apache is running on Port 8080 (Day 3 MLOps)</h1>" | sudo tee /var/www/html/apache_index.html > /dev/null
    sudo sed -i 's/DocumentRoot \/var\/www\/html/DocumentRoot \/var\/www\/html\n\tDirectoryIndex apache_index.html/' /etc/apache2/sites-available/000-default.conf

    # 5. Service Management
    sudo systemctl enable apache2
    sudo systemctl restart apache2
    log_info "✓ Service started and enabled"

    # 6. Verification
    if curl -s http://localhost:8080 | grep -q "Apache is running"; then
        log_info "✓ Test page accessible on port 8080"
        log_info "Status: Ready"
    else
        log_info "❌ Connection test FAILED."
        exit 1
    fi
    
    echo "=================================="
}

main "$@"