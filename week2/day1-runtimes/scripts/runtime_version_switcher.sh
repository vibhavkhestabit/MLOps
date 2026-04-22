#!/bin/bash

# Script: runtime_version_switcher.sh
# Description: Interactive menu to switch Node.js, Python, and PHP versions.
# Author: Vibhav Khaneja
# Date: 2026-04-22

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="${SCRIPT_DIR}/logs"
LOG_FILE="${LOG_DIR}/runtime_version_switcher.log"

mkdir -p "$LOG_DIR"

log_info() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $1" | tee -a "$LOG_FILE"; }

# Explicitly load NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Explicitly load PYENV
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
    eval "$(pyenv init -)"
fi

show_menu() {
    echo "=========================================="
    echo "Select runtime to switch:"
    echo "1) Node.js"
    echo "2) Python"
    echo "3) PHP"
    echo "4) Show all versions"
    echo "5) Exit"
    echo "=========================================="
}

log_info "Starting interactive runtime switcher."

while true; do
    show_menu
    read -rp "Choice: " choice

    case $choice in
        1)
            echo "Available Node versions:"
            nvm ls --no-colors | grep -E 'v18|v20|v22'
            read -rp "Enter exact version to use (e.g., v22.0.0): " node_ver
            nvm use "$node_ver"
            log_info "Switched to Node.js $node_ver"
            ;;
        2)
            echo "Available Python versions:"
            pyenv versions
            read -rp "Enter exact version to use (e.g., 3.12.1): " py_ver
            pyenv global "$py_ver"
            log_info "Switched to Python $py_ver"
            ;;
        3)
            echo "Available PHP versions:"
            ls /usr/bin/php* | grep -E 'php[0-9]\.[0-9]$' | awk -F'/' '{print $4}'
            read -rp "Enter exact version to use (e.g., php8.3): " php_ver
            sudo update-alternatives --set php "/usr/bin/$php_ver"
            log_info "Switched to $php_ver"
            ;;
        4)
            echo "--- Installed Node.js ---"
            nvm ls --no-colors | grep -E 'v18|v20|v22'
            echo "--- Installed Python ---"
            pyenv versions
            echo "--- Installed PHP ---"
            ls /usr/bin/php* | grep -E 'php[0-9]\.[0-9]$'
            ;;
        5)
            log_info "Exiting runtime switcher."
            break
            ;;
        *)
            echo "Invalid option. Please try again."
            ;;
    esac
done