#!/bin/bash
set -euo pipefail

# Script: run_migrations.sh
# Description: Enterprise watchdog for PM2 and Systemd applications.
# Author: Vibhav Khaneja

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="${SCRIPT_DIR}/logs"
LOG_FILE="${LOG_DIR}/migration_runner.log"

# --- DATABASE CREDENTIALS (Update these if your Day 2 setup was different!) ---
PG_USER="dbadmin"
PG_DB="testdb"
MYSQL_USER="root"
MYSQL_PASS="RootP@ssw0rd123" # Put your MySQL root password here
MYSQL_DB="appdb"
# -----------------------------------------------------------------------------

mkdir -p "$LOG_DIR"

log_info() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $1" | tee -a "$LOG_FILE"; }
log_error() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $1" | tee -a "$LOG_FILE" >&2; }

print_result() {
    local status=$1
    local message=$2
    if [[ "$status" == "PASS" ]]; then
        echo -e "[\033[32mPASS\033[0m] $message"
    else
        echo -e "[\033[31mFAIL\033[0m] $message"
    fi
}

main() {
    log_info "Starting Database Migrations..."
    echo "======================================"
    echo "       ENTERPRISE MIGRATION RUNNER    "
    echo "======================================"

    local final_status=0

    # 1. Laravel (PHP / MySQL) Migrations
    log_info "Migrating Stack 2: Laravel (MySQL)..."
    if cd "${SCRIPT_DIR}/laravel-mysql-api" && php artisan migrate --force >> "$LOG_FILE" 2>&1; then
        print_result "PASS" "Laravel database migrated successfully."
    else
        print_result "FAIL" "Laravel migration failed. Check logs."
        final_status=1
    fi

    # 2. Express (Node.js / PostgreSQL) Migrations 
    log_info "Migrating Stack 1: Express (PostgreSQL)..."
    if psql -h localhost -U "$PG_USER" -d "$PG_DB" -f "${SCRIPT_DIR}/express-postgresql-api/migrations/001_create_users_table.sql" >> "$LOG_FILE" 2>&1; then
        print_result "PASS" "Express database migrated successfully."
    else
        print_result "FAIL" "Express migration failed. Verify PostgreSQL is running and credentials match."
        final_status=1
    fi

    # 3. FastAPI (Python / MySQL) Migrations
    log_info "Migrating Stack 3: FastAPI (MySQL)..."
    # Using mysql command to pipe the SQL file into the database
    if mysql -h localhost -u "$MYSQL_USER" -p"$MYSQL_PASS" "$MYSQL_DB" < "${SCRIPT_DIR}/fastapi-mysql-api/migrations/001_create_products_table.sql" 2>> "$LOG_FILE"; then
        print_result "PASS" "FastAPI database migrated successfully."
    else
        print_result "FAIL" "FastAPI migration failed. Verify MySQL is running and credentials match."
        final_status=1
    fi

    echo "======================================"
    
    if [[ $final_status -eq 0 ]]; then
        log_info "All automated migrations completed. Databases are SYNCED."
    else
        log_error "One or more migrations failed. Databases are OUT OF SYNC."
    fi

    exit $final_status
}

main "$@"