#!/bin/bash
set -eo pipefail

# Script: webserver_performance_tuner.sh
# Description: Optimizes Nginx and Apache buffers, connections, and timeouts.
# Author: Vibhav Khaneja
# Date: 2026-04-24

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="${SCRIPT_DIR}/../logs"
LOG_FILE="${LOG_DIR}/performance_tuning.log"

log_info() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $1" | tee -a "$LOG_FILE"; }

main() {
    log_info "========== Web Server Performance Tuner =========="
    
    # --- NGINX OPTIMIZATION ---
    log_info "Tuning Nginx..."
    local NGINX_CONF="/etc/nginx/nginx.conf"
    sudo cp "$NGINX_CONF" "${NGINX_CONF}.tuning_backup"

    # Injecting advanced buffer settings (Removed gzip and keepalive to prevent duplicate conflicts)
    sudo bash -c "cat > /etc/nginx/conf.d/performance.conf" <<EOF
# Buffer size optimizations (Prevents writing to disk for standard requests)
client_body_buffer_size 16K;
client_header_buffer_size 1k;
client_max_body_size 8m;
large_client_header_buffers 2 1k;

# Gzip Aggressive Compression Tweaks (Main 'gzip on' is already in nginx.conf)
gzip_comp_level 6;
gzip_min_length 256;
EOF

    # --- APACHE OPTIMIZATION ---
    log_info "Tuning Apache..."
    local APACHE_CONF="/etc/apache2/apache2.conf"
    sudo cp "$APACHE_CONF" "${APACHE_CONF}.tuning_backup"

    # Injecting optimized KeepAlive and Timeout settings
    sudo sed -i 's/Timeout 300/Timeout 60/' "$APACHE_CONF"
    sudo sed -i 's/KeepAliveTimeout 5/KeepAliveTimeout 15/' "$APACHE_CONF"

    # --- VERIFICATION ---
    log_info "Testing and applying configurations..."
    
    # Notice we removed >/dev/null here. If it fails, we WANT to see the error!
    if sudo nginx -t && sudo apachectl configtest; then
        sudo systemctl reload nginx
        sudo systemctl reload apache2
        log_info "✓ Optimizations successfully applied to both servers."
    else
        log_info " Configuration test failed. Reverting..."
        sudo mv "${NGINX_CONF}.tuning_backup" "$NGINX_CONF"
        sudo mv "${APACHE_CONF}.tuning_backup" "$APACHE_CONF"
        # Remove the conflicting file just in case
        sudo rm -f /etc/nginx/conf.d/performance.conf 
        exit 1
    fi
    echo "=================================================="
}

main