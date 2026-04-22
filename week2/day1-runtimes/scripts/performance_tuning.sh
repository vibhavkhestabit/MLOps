#!/bin/bash
set -euo pipefail

# Script: performance_tuning.sh
# Description: Applies system-wide runtime performance optimizations.
# Author: Vibhav Khaneja
# Date: 2026-04-22
# Usage: ./performance_tuning.sh

readonly EXIT_SUCCESS=0
readonly EXIT_ERROR=1

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="${SCRIPT_DIR}/logs"
LOG_FILE="${LOG_DIR}/$(basename "$0" .sh).log"
CONFIGS_DIR="${SCRIPT_DIR}/performance_configs"

mkdir -p "$LOG_DIR" "$CONFIGS_DIR"

log_info() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $1" | tee -a "$LOG_FILE"; }
log_error() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $1" | tee -a "$LOG_FILE" >&2; }

main() {
    log_info "Starting performance tuning configuration."

    # Node.js Optimization
    log_info "Tuning Node.js..."
    echo "--max-old-space-size=4096" > "${CONFIGS_DIR}/node-options"
    echo "--max-http-header-size=16384" >> "${CONFIGS_DIR}/node-options"
    
    local NODE_OPTS
    NODE_OPTS=$(cat "${CONFIGS_DIR}/node-options" | tr '\n' ' ')
    if ! grep -q "export NODE_OPTIONS=" "$HOME/.bashrc"; then
        echo "export NODE_OPTIONS=\"$NODE_OPTS\"" >> "$HOME/.bashrc"
        log_info "Injected NODE_OPTIONS into .bashrc"
    fi

    # Python Optimization
    log_info "Tuning Python..."
    echo "export PYTHONOPTIMIZE=1" > "${CONFIGS_DIR}/python-env"
    echo "export PYTHONUNBUFFERED=1" >> "${CONFIGS_DIR}/python-env"
    
    if ! grep -q "export PYTHONOPTIMIZE=1" "$HOME/.bashrc"; then
        cat "${CONFIGS_DIR}/python-env" >> "$HOME/.bashrc"
        log_info "Injected Python optimizations into .bashrc"
    fi

    # PHP Optimization
    log_info "Tuning PHP..."
    for version in 7.4 8.1 8.2 8.3; do
        local php_ini="/etc/php/$version/fpm/php.ini"
        if [ -f "$php_ini" ]; then
            sudo sed -i 's/^memory_limit = .*/memory_limit = 256M/' "$php_ini"
            sudo sed -i 's/^max_execution_time = .*/max_execution_time = 300/' "$php_ini"
            sudo sed -i 's/^;opcache.enable=1/opcache.enable=1/' "$php_ini"
            sudo sed -i 's/^;opcache.memory_consumption=128/opcache.memory_consumption=128/' "$php_ini"
            
            sudo systemctl restart "php$version-fpm"
            log_info "Optimized and restarted PHP $version FPM."
        fi
    done

    log_info "Performance optimizations applied successfully."
    echo "Please run 'source ~/.bashrc' to apply exported variables to your current shell."
    
    exit $EXIT_SUCCESS
}

main "$@"