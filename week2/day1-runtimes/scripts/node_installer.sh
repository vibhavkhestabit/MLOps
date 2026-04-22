#!/bin/bash
set -eo pipefail

# Script: node_installer.sh
# Description: Installs nvm automatically and sets up Node.js v18, v20, and v22.
# Author: Vibhav Khaneja
# Date: 2026-04-22
# Usage: ./node_installer.sh

readonly EXIT_SUCCESS=0
readonly EXIT_ERROR=1

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="${SCRIPT_DIR}/logs"
LOG_FILE="${LOG_DIR}/$(basename "$0" .sh).log"

mkdir -p "$LOG_DIR"

log_info() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $1" | tee -a "$LOG_FILE"; }
log_error() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $1" | tee -a "$LOG_FILE" >&2; }

main() {
    log_info "========== NODE.JS INSTALLATION =========="
    log_info "Installing nvm..."
    
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash > /dev/null 2>&1
    
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    
    log_info "nvm installed successfully."

    for version in v18.19.0 v20.11.0 v22.0.0; do
        log_info "Installing Node.js $version..."
        nvm install "$version" > /dev/null 2>&1
        log_info "Node.js $version installed."
    done

    nvm alias default v20.11.0 > /dev/null 2>&1
    nvm use default > /dev/null 2>&1
    log_info "Node.js v20.11.0 installed (DEFAULT)."

    echo "=========================================="
    log_info "Verification:"
    node --version | tee -a "$LOG_FILE"
    npm --version | tee -a "$LOG_FILE"

    echo "v20.11.0" > "$HOME/.nvmrc"
    log_info "Created .nvmrc in home directory."

    echo "=========================================="
    log_info "Node versions available:"
    nvm ls --no-colors | grep -E 'v18|v20|v22' | tee -a "$LOG_FILE"
    
    log_info "Installation completed successfully."
    exit $EXIT_SUCCESS
}

main "$@"