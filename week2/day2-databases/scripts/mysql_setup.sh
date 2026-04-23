#!/bin/bash
set -eo pipefail

# Script: mysql_setup.sh
# Description: Installs MySQL 8.0, secures it, optimizes InnoDB, enables binlogs.
# Author: Vibhav Khaneja
# Date: 2026-04-23

readonly EXIT_SUCCESS=0
readonly EXIT_ERROR=1

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="${SCRIPT_DIR}/../logs"
LOG_FILE="${LOG_DIR}/mysql_setup.log"

mkdir -p "$LOG_DIR"

log_info() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $1" | tee -a "$LOG_FILE"; }
log_error() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $1" | tee -a "$LOG_FILE" >&2; }

main() {
    log_info "========== MySQL Setup =========="
    
    # 1. Install MySQL 8.0
    log_info "Installing MySQL 8.0 Server..."
    sudo apt-get update > /dev/null 2>&1
    sudo apt-get install -y mysql-server > /dev/null 2>&1
    sudo systemctl start mysql
    log_info "✓ MySQL 8.0 installed"

    # 2. Automated Secure Installation
    log_info "Securing MySQL installation..."
    sudo mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'RootP@ssw0rd123';"
    sudo mysql -u root -p'RootP@ssw0rd123' -e "DELETE FROM mysql.user WHERE User='';"
    sudo mysql -u root -p'RootP@ssw0rd123' -e "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');"
    sudo mysql -u root -p'RootP@ssw0rd123' -e "DROP DATABASE IF EXISTS test; DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';"
    sudo mysql -u root -p'RootP@ssw0rd123' -e "FLUSH PRIVILEGES;"
    log_info "✓ Installation secured (anonymous users removed, root locked, test db dropped)"

    # 3. Create optimized my.cnf overrides
    local MY_CNF_CUSTOM="/etc/mysql/mysql.conf.d/99-custom-opt.cnf"
    log_info "Applying InnoDB optimizations and binary logging..."
    sudo tee "$MY_CNF_CUSTOM" > /dev/null <<EOF
[mysqld]
innodb_buffer_pool_size = 512M
innodb_log_file_size = 128M
max_connections = 150
log_bin = /var/log/mysql/mysql-bin.log
server-id = 1
# query_cache_size is deprecated and removed in MySQL 8.0
EOF
    sudo cp "$MY_CNF_CUSTOM" "${SCRIPT_DIR}/../configs/my.cnf.optimized"
    
    sudo systemctl restart mysql
    log_info "✓ Configuration optimized and service restarted"

    # 4. Create App User and DB
    log_info "Creating 'appuser' and 'appdb'..."
    sudo mysql -u root -p'RootP@ssw0rd123' -e "CREATE DATABASE appdb;"
    sudo mysql -u root -p'RootP@ssw0rd123' -e "CREATE USER 'appuser'@'%' IDENTIFIED BY 'AppP@ssw0rd123';"
    sudo mysql -u root -p'RootP@ssw0rd123' -e "GRANT ALL PRIVILEGES ON appdb.* TO 'appuser'@'%';"
    sudo mysql -u root -p'RootP@ssw0rd123' -e "FLUSH PRIVILEGES;"
    log_info "✓ Test database 'appdb' and 'appuser' created"

    # 5. Verification
    if mysql -u appuser -p'AppP@ssw0rd123' -e "SELECT 1;" > /dev/null 2>&1; then
        log_info "✓ Connection test: SUCCESSFUL"
        log_info "Status: Ready for production"
    else
        log_error "Connection test FAILED."
        exit $EXIT_ERROR
    fi

    echo "================================="
    exit $EXIT_SUCCESS
}

main "$@"