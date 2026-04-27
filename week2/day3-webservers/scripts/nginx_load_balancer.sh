#!/bin/bash
set -eo pipefail

# Script: nginx_load_balancer.sh
# Description: Configures Nginx to distribute traffic across multiple upstream servers.
# Author: Vibhav Khaneja
# Date: 2026-04-24

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="${SCRIPT_DIR}/../logs"
LOG_FILE="${LOG_DIR}/nginx_lb.log"
mkdir -p "$LOG_DIR"

log_info() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $1" | tee -a "$LOG_FILE"; }

# Using the certs we generated earlier
DOMAIN="devops.local"
CERT_PATH="/etc/ssl/certs/${DOMAIN}.crt"
KEY_PATH="/etc/ssl/private/${DOMAIN}.key"
LB_DOMAIN="lb.${DOMAIN}"
CONF_FILE="/etc/nginx/sites-available/load-balancer.conf"

main() {
    log_info "========== Nginx Load Balancer Setup =========="
    
    log_info "Adding $LB_DOMAIN to /etc/hosts for local testing..."
    if ! grep -q "$LB_DOMAIN" /etc/hosts; then
        echo "127.0.0.1 $LB_DOMAIN" | sudo tee -a /etc/hosts >/dev/null
    fi

    log_info "Generating Load Balancer configuration..."
    
    sudo bash -c "cat > $CONF_FILE" <<EOF
# 1. Define the Upstream Cluster
upstream app_cluster {
    # Algorithm: Send traffic to the server with the fewest active connections
    least_conn; 
    
    # Active Nodes with Health Checks
    server 127.0.0.1:3001 max_fails=3 fail_timeout=30s;
    server 127.0.0.1:3002 max_fails=3 fail_timeout=30s;
    server 127.0.0.1:3003 max_fails=3 fail_timeout=30s;
    
    # Fallback Server (Only used if 3001, 3002, and 3003 all crash)
    server 127.0.0.1:3004 backup;
}

# 2. HTTP to HTTPS Redirect
server {
    listen 80;
    server_name $LB_DOMAIN;
    return 301 https://\$host\$request_uri;
}

# 3. Secure Load Balancer Gateway
server {
    listen 443 ssl;
    server_name $LB_DOMAIN;

    ssl_certificate $CERT_PATH;
    ssl_certificate_key $KEY_PATH;

    location / {
        # Route traffic to the 'app_cluster' defined above
        proxy_pass http://app_cluster;
        
        # If a server throws an error or times out, immediately try the next one
        proxy_next_upstream error timeout http_500 http_502 http_503;
        
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
    }
}
EOF

    log_info "Enabling Load Balancer configuration..."
    sudo ln -sf "$CONF_FILE" "/etc/nginx/sites-enabled/"

    log_info "Testing Nginx configuration syntax..."
    if sudo nginx -t; then
        log_info "Syntax OK. Reloading Nginx daemon..."
        sudo systemctl reload nginx
        log_info "✓ Load Balancer successfully configured and activated."
    else
        log_info " Nginx configuration test failed."
        exit 1
    fi
    echo "============================================="
}

main