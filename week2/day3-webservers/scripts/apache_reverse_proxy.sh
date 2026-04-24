#!/bin/bash
set -eo pipefail

# Script: apache_reverse_proxy.sh
# Description: Generates Apache reverse proxy configurations with SSL.
# Author: Vibhav Khaneja
# Date: 2026-04-24

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="${SCRIPT_DIR}/../logs"
LOG_FILE="${LOG_DIR}/apache_proxy.log"

log_info() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $1" | tee -a "$LOG_FILE"; }

# Dummy domain and cert paths
DOMAIN="devops.local"
CERT_PATH="/etc/ssl/certs/${DOMAIN}.crt"
KEY_PATH="/etc/ssl/private/${DOMAIN}.key"
CONF_FILE="/etc/apache2/sites-available/nodejs-proxy.conf"

main() {
    log_info "========== Apache Reverse Proxy Setup =========="
    
    log_info "Enabling required Apache proxy modules..."
    sudo a2enmod proxy proxy_http proxy_wstunnel ssl headers >/dev/null 2>&1
    
    log_info "Generating VirtualHost configuration..."
    sudo bash -c "cat > $CONF_FILE" <<EOF
<VirtualHost *:8443>
    ServerName apache-nodejs.$DOMAIN

    # SSL Configuration
    SSLEngine on
    SSLCertificateFile $CERT_PATH
    SSLCertificateKeyFile $KEY_PATH

    # Proxy Configuration
    ProxyPreserveHost On
    ProxyRequests Off
    
    # Websocket Support
    RewriteEngine On
    RewriteCond %{HTTP:Upgrade} =websocket [NC]
    RewriteRule /(.*)           ws://127.0.0.1:3000/\$1 [P,L]

    # HTTP Proxy
    ProxyPass / http://127.0.0.1:3000/
    ProxyPassReverse / http://127.0.0.1:3000/

    # Security Headers
    Header always set Strict-Transport-Security "max-age=63072000"
    Header always set X-Frame-Options "SAMEORIGIN"
</VirtualHost>
EOF

    log_info "Enabling the new site..."
    sudo a2ensite nodejs-proxy.conf >/dev/null 2>&1

    log_info "Testing Apache configuration..."
    if sudo apachectl configtest 2>/dev/null; then
        log_info "Syntax OK. Reloading Apache daemon..."
        sudo systemctl reload apache2
        log_info "✓ Apache Reverse Proxy successfully configured!"
    else
        log_info "❌ Apache configuration test failed."
        exit 1
    fi
    echo "==============================================="
}

main