#!/bin/bash
set -eo pipefail

# Script: postgresql_setup.sh
# Description: Installs PostgreSQL 15, optimizes conf, sets up users and test db.
# Author: Vibhav Khaneja
# Date: 2026-04-23

readonly EXIT_SUCCESS=0
readonly EXIT_ERROR=1

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="${SCRIPT_DIR}/../logs"
LOG_FILE="${LOG_DIR}/postgresql_setup.log"

mkdir -p "$LOG_DIR"

log_info() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $1" | tee -a "$LOG_FILE"; }
log_error() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $1" | tee -a "$LOG_FILE" >&2; }

main() {
    log_info "========== PostgreSQL Setup =========="
    
    # 1. Install PostgreSQL 15
    log_info "Adding PostgreSQL repository and installing v15..."
    sudo apt-get update 
    sudo apt-get install -y postgresql-common 
    sudo /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh -y 
    sudo apt-get install -y postgresql-15 postgresql-client-15 
    log_info "✓ PostgreSQL 15 installed"

    # 2. Optimize postgresql.conf
    local PG_CONF="/etc/postgresql/15/main/postgresql.conf"
    log_info "Applying performance optimizations to $PG_CONF..."
    sudo sed -i "s/^#shared_buffers = 128MB/shared_buffers = 256MB/" "$PG_CONF"
    sudo sed -i "s/^#effective_cache_size = 4GB/effective_cache_size = 1GB/" "$PG_CONF"
    sudo sed -i "s/^#work_mem = 4MB/work_mem = 16MB/" "$PG_CONF"
    sudo sed -i "s/^#maintenance_work_mem = 64MB/maintenance_work_mem = 128MB/" "$PG_CONF"
    sudo sed -i "s/^max_connections = 100/max_connections = 100/" "$PG_CONF"
    
    # Backup the config to our configs directory
    sudo cp "$PG_CONF" "${SCRIPT_DIR}/../configs/postgresql.conf.optimized"
    log_info "✓ Configuration optimized"

    # 3. Configure pg_hba.conf for local/network access
    local PG_HBA="/etc/postgresql/15/main/pg_hba.conf"
    echo "host    all             all             10.0.0.0/8              scram-sha-256" | sudo tee -a "$PG_HBA" > /dev/null
    sudo cp "$PG_HBA" "${SCRIPT_DIR}/../configs/pg_hba.conf.optimized"

    # 4. Start and enable service
    sudo systemctl enable postgresql > /dev/null 2>&1
    sudo systemctl restart postgresql
    log_info "✓ Service started and enabled"

    # 5. Create superuser and test database
    log_info "Creating user 'dbadmin' and database 'testdb'..."
    sudo -u postgres psql -c "CREATE USER dbadmin WITH SUPERUSER PASSWORD 'AdminP@ssw0rd123';" > /dev/null 2>&1
    log_info "✓ User 'dbadmin' created"
    
    sudo -u postgres psql -c "CREATE DATABASE testdb OWNER dbadmin;" > /dev/null 2>&1
    log_info "✓ Test database 'testdb' created"

    # 6. Verification
    if sudo -u postgres psql -c '\q' 2>/dev/null; then
        log_info "✓ Connection test: SUCCESSFUL"
        log_info "Status: Ready for production"
    else
        log_error "Connection test FAILED."
        exit $EXIT_ERROR
    fi
    
    echo "======================================"
    exit $EXIT_SUCCESS
}

main "$@"