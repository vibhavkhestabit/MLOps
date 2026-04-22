#!/bin/bash
set -eo pipefail

# Script: runtime_audit.sh
# Description: Scans the system and reports all installed runtime versions.
# Author: Vibhav Khaneja
# Date: 2026-04-22
# Usage: ./runtime_audit.sh

readonly EXIT_SUCCESS=0
readonly EXIT_ERROR=1

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="${SCRIPT_DIR}/logs"
LOG_FILE="${LOG_DIR}/$(basename "$0" .sh).log"
DOCS_DIR="$(cd "${SCRIPT_DIR}/.." && pwd)/docs"
REPORT_FILE="${DOCS_DIR}/runtime_audit_report.txt"

mkdir -p "$LOG_DIR" "$DOCS_DIR"

log_info() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $1" | tee -a "$LOG_FILE"; }
log_error() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $1" | tee -a "$LOG_FILE" >&2; }

# Initialize version managers for subshell
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path 2>/dev/null)" || true

main() {
    log_info "Starting runtime audit scan."

    echo "RUNTIME AUDIT REPORT" > "$REPORT_FILE"
    echo "Generated: $(date '+%Y-%m-%d %H:%M:%S')" >> "$REPORT_FILE"
    echo "==========================================================================================" >> "$REPORT_FILE"
    printf "%-10s | %-30s | %-10s | %-20s\n" "RUNTIME" "INSTALLED VERSIONS" "DEFAULT" "PATH" >> "$REPORT_FILE"
    echo "-----------|--------------------------------|------------|--------------------------------" >> "$REPORT_FILE"

    # Node.js
    local NODE_VERSIONS
    NODE_VERSIONS=$(ls "$HOME/.nvm/versions/node" 2>/dev/null | tr '\n' ',' | sed 's/,$//' || echo "None")
    local NODE_DEFAULT
    NODE_DEFAULT=$(cat "$HOME/.nvm/alias/default" 2>/dev/null || echo "None")
    local NODE_PATH="~/.nvm/versions/node"
    printf "%-10s | %-30s | %-10s | %-20s\n" "Node.js" "$NODE_VERSIONS" "$NODE_DEFAULT" "$NODE_PATH" >> "$REPORT_FILE"

    # Python
    local PY_VERSIONS
    PY_VERSIONS=$(ls "$HOME/.pyenv/versions" 2>/dev/null | grep -v 'venv' | tr '\n' ',' | sed 's/,$//' || echo "None")
    local PY_DEFAULT
    PY_DEFAULT=$(pyenv global 2>/dev/null || echo "None")
    local PY_PATH="~/.pyenv/versions"
    printf "%-10s | %-30s | %-10s | %-20s\n" "Python" "$PY_VERSIONS" "$PY_DEFAULT" "$PY_PATH" >> "$REPORT_FILE"

    # PHP
    local PHP_VERSIONS
    PHP_VERSIONS=$(ls /etc/php 2>/dev/null | tr '\n' ',' | sed 's/,$//' || echo "None")
    local PHP_DEFAULT
    PHP_DEFAULT=$(php -r 'echo PHP_MAJOR_VERSION.".".PHP_MINOR_VERSION;' 2>/dev/null || echo "None")
    local PHP_PATH="/etc/php"
    printf "%-10s | %-30s | %-10s | %-20s\n" "PHP" "$PHP_VERSIONS" "$PHP_DEFAULT" "$PHP_PATH" >> "$REPORT_FILE"

    cat "$REPORT_FILE"
    log_info "Audit completed. Report saved to $REPORT_FILE"
    
    exit $EXIT_SUCCESS
}

main "$@"