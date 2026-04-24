#!/bin/bash
set -eo pipefail

# Script: nginx_reverse_proxy.sh
# Description: Generates Nginx reverse proxy configs for multiple backend apps.
# Author: Vibhav Khaneja
# Date: 2026-04-24

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="${SCRIPT_DIR}/../logs"
LOG_FILE="${LOG_DIR}/nginx_proxy.log"
mkdir -p "$LOG_DIR"

log_info() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $1" | tee -a "$LOG_FILE"; }

# The dummy domain and certificates we just created
DOMAIN="devops.local"
CERT_PATH="/etc/ssl/certs/${DOMAIN}.crt"
KEY_PATH="/etc/ssl/private/${DOMAIN}.key"

create_proxy_config() {
    local app_name=$1
    local port=$2
    local subdomain="${app_name}.${DOMAIN}"
    local conf_file="/etc/nginx/sites-available/${app_name}-app.conf"

    log_info "Generating configuration for $subdomain (Port $port)..."
    
    # We use sudo bash -c to safely write complex multi-line blocks into protected directories
    sudo bash -c "cat > $conf_file" <<EOF
# HTTP to HTTPS Redirect Block
server {
    listen 80;
    server_name $subdomain;
    return 301 https://\$host\$request_uri;
}

# HTTPS Secure Server Block
server {
    listen 443 ssl;
    server_name $subdomain;

    # Apply our generated SSL certificates
    ssl_certificate $CERT_PATH;
    ssl_certificate_key $KEY_PATH;

    # SSL Security Best Practices
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;

    location / {
        proxy_pass http://127.0.0.1:$port;
        
        # Websocket Support (Critical for Node.js/Real-time apps)
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        
        # Forward accurate client IP data to the backend
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }
}
EOF

    # Enable the site by creating a symbolic link
    sudo ln -sf "$conf_file" "/etc/nginx/sites-enabled/"
}

main() {
    log_info "========== Nginx Reverse Proxy Setup =========="
    
    # Check if the certs actually exist before proceeding
    if [ ! -f "$CERT_PATH" ]; then
        log_info " Error: SSL Certificate not found at $CERT_PATH"
        exit 1
    fi

    # Unlink the default Nginx page so it doesn't conflict with our routing
    sudo rm -f /etc/nginx/sites-enabled/default

    # Create proxy files for our three backend stacks
    create_proxy_config "nodejs" "3000"
    create_proxy_config "python" "8000"
    create_proxy_config "php" "9000"

    log_info "Testing Nginx configuration syntax..."
    if sudo nginx -t; then
        log_info "Syntax OK. Reloading Nginx daemon..."
        sudo systemctl reload nginx
        log_info "✓ Reverse proxies successfully configured and activated."
    else
        log_info " Nginx configuration test failed. Reverting..."
        exit 1
    fi
    echo "============================================="
}

main