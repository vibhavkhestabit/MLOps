#!/bin/bash
set -euo pipefail

# Script: php_installer.sh
# Description: Installs PHP versions 7.4, 8.1, 8.2, 8.3 and sets up php-fpm.
# Author: Vibhav Khaneja
# Date: 2026-04-22
# Usage: ./php_installer.sh

readonly EXIT_SUCCESS=0
readonly EXIT_ERROR=1

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="${SCRIPT_DIR}/logs"
LOG_FILE="${LOG_DIR}/$(basename "$0" .sh).log"

mkdir -p "$LOG_DIR"

log_info() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $1" | tee -a "$LOG_FILE"; }
log_error() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $1" | tee -a "$LOG_FILE" >&2; }

main() {
    log_info "========== PHP INSTALLATION =========="
    
    sudo apt-get update > /dev/null 2>&1
    sudo apt-get install -y software-properties-common curl unzip > /dev/null 2>&1

    log_info "Adding ondrej/php PPA..."
    sudo add-apt-repository ppa:ondrej/php -y > /dev/null 2>&1
    sudo apt-get update > /dev/null 2>&1

    for version in 7.4 8.1 8.2 8.3; do
        log_info "Installing PHP $version and dependencies..."
        sudo apt-get install -y "php$version" "php$version-fpm" "php$version-cli" \
            "php$version-common" "php$version-mysql" "php$version-zip" "php$version-gd" \
            "php$version-mbstring" "php$version-curl" "php$version-xml" "php$version-bcmath" > /dev/null 2>&1
        
        sudo cp "/etc/php/$version/fpm/php.ini" "/etc/php/$version/fpm/php.ini.template"
    done

    log_info "Setting PHP 8.2 as default CLI version..."
    sudo update-alternatives --set php /usr/bin/php8.2 > /dev/null 2>&1

    log_info "Installing Composer globally..."
    curl -sS https://getcomposer.org/installer | php > /dev/null 2>&1
    sudo mv composer.phar /usr/local/bin/composer

    log_info "Starting and enabling php8.2-fpm service..."
    sudo systemctl enable php8.2-fpm > /dev/null 2>&1
    sudo systemctl start php8.2-fpm

    echo "=========================================="
    log_info "Verification:"
    php --version | head -n 1 | tee -a "$LOG_FILE"
    composer --version | tee -a "$LOG_FILE"

    log_info "Installation completed successfully."
    exit $EXIT_SUCCESS
}

main "$@"