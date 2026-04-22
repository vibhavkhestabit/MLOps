#!/bin/bash
set -eo pipefail

# Script: python_installer.sh
# Description: Installs pyenv, dependencies, and Python 3.9, 3.10, 3.11, 3.12.
# Author: Vibhav Khaneja
# Date: 2026-04-22
# Usage: ./python_installer.sh

readonly EXIT_SUCCESS=0
readonly EXIT_ERROR=1

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="${SCRIPT_DIR}/logs"
LOG_FILE="${LOG_DIR}/$(basename "$0" .sh).log"

mkdir -p "$LOG_DIR"

log_info() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $1" | tee -a "$LOG_FILE"; }
log_error() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $1" | tee -a "$LOG_FILE" >&2; }

main() {
    log_info "========== PYTHON INSTALLATION =========="
    log_info "Installing build dependencies..."
    
    sudo apt-get update > /dev/null 2>&1
    sudo apt-get install -y make build-essential libssl-dev zlib1g-dev \
        libbz2-dev libreadline-dev libsqlite3-dev wget curl llvm libncurses5-dev \
        libncursesw5-dev xz-utils tk-dev libffi-dev liblzma-dev git > /dev/null 2>&1

    log_info "Installing pyenv..."
    curl -L https://pyenv.run | bash > /dev/null 2>&1

    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init --path)"
    eval "$(pyenv virtualenv-init -)"

    log_info "pyenv installed successfully."

    for version in 3.9.18 3.10.13 3.11.7 3.12.1; do
        log_info "Installing Python $version..."
        pyenv install -s "$version"
    done

    pyenv global 3.11.7
    log_info "Set global default to Python 3.11.7."

    log_info "Installing essential packages..."
    pip install --upgrade pip virtualenv pipenv > /dev/null 2>&1

    mkdir -p "$HOME/venv_templates"
    log_info "Created virtual environment template directory."

    echo "=========================================="
    log_info "Verification:"
    python --version | tee -a "$LOG_FILE"
    pip --version | tee -a "$LOG_FILE"

    log_info "Installation completed successfully."
    exit $EXIT_SUCCESS
}

main "$@"