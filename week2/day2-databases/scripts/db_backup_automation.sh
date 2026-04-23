#!/bin/bash
set -eo pipefail

# Script: db_backup_automation.sh
# Description: Performs compressed, rotating backups for PostgreSQL, MySQL, and MongoDB.
# Author: Vibhav Khaneja
# Date: 2026-04-23

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_ROOT="${SCRIPT_DIR}/../backups"
LOG_DIR="${SCRIPT_DIR}/../logs"
REPORT_FILE="${LOG_DIR}/backup_report_$(date '+%Y-%m-%d').txt"

mkdir -p "$LOG_DIR"
touch "$REPORT_FILE"

# Credentials (In production, use secure vaults)
PG_USER="postgres"
MYSQL_PASS="RootP@ssw0rd123"
MONGO_PASS="AdminP@ssw0rd123"

log_info() { 
    local msg="[$(date '+%Y-%m-%d %H:%M:%S')] $1"
    echo "$msg" | tee -a "$REPORT_FILE"
}

# Determine rotation directory based on the day of the week/month
DAY_OF_WEEK=$(date +%u) # 1-7 (Monday-Sunday)
DAY_OF_MONTH=$(date +%d) # 01-31
TIMESTAMP=$(date '+%Y%m%d_%H%M%S')

get_rotation_dir() {
    if [ "$DAY_OF_MONTH" -eq 1 ]; then
        echo "monthly"
    elif [ "$DAY_OF_WEEK" -eq 7 ]; then
        echo "weekly"
    else
        echo "daily"
    fi
}

ROTATION=$(get_rotation_dir)

backup_postgres() {
    log_info "Starting PostgreSQL backup ($ROTATION)..."
    local DEST_DIR="${BACKUP_ROOT}/postgresql/${ROTATION}/$(date '+%Y-%m-%d')"
    mkdir -p "$DEST_DIR"
    
    local FILE="${DEST_DIR}/all_databases_${TIMESTAMP}.sql.gz"
    
    # pg_dumpall captures all databases and roles. We pipe it directly to gzip.
    if sudo -u "$PG_USER" pg_dumpall | gzip > "$FILE"; then
        local SIZE=$(du -h "$FILE" | cut -f1)
        log_info "✓ PostgreSQL backup successful: $FILE ($SIZE)"
    else
        log_info " PostgreSQL backup failed!"
    fi
}

backup_mysql() {
    log_info "Starting MySQL backup ($ROTATION)..."
    local DEST_DIR="${BACKUP_ROOT}/mysql/${ROTATION}/$(date '+%Y-%m-%d')"
    mkdir -p "$DEST_DIR"
    
    local FILE="${DEST_DIR}/all_databases_${TIMESTAMP}.sql.gz"
    
    # mysqldump with --single-transaction ensures data consistency without locking tables
    if sudo mysqldump -u root -p"$MYSQL_PASS" --all-databases --single-transaction --routines --events | gzip > "$FILE" 2>/dev/null; then
        local SIZE=$(du -h "$FILE" | cut -f1)
        log_info "✓ MySQL backup successful: $FILE ($SIZE)"
    else
        log_info " MySQL backup failed!"
    fi
}

backup_mongodb() {
    log_info "Starting MongoDB backup ($ROTATION)..."
    local DEST_DIR="${BACKUP_ROOT}/mongodb/${ROTATION}/$(date '+%Y-%m-%d')"
    mkdir -p "$DEST_DIR"
    
    local FILE="${DEST_DIR}/all_databases_${TIMESTAMP}.archive.gz"
    
    # mongodump creates a compressed archive of all BSON data using explicit flags
    if mongodump --host="127.0.0.1:27017" --username="admin" --password="${MONGO_PASS}" --authenticationDatabase="admin" --archive="$FILE" --gzip >/dev/null 2>&1; then
        local SIZE=$(du -h "$FILE" | cut -f1)
        log_info "✓ MongoDB backup successful: $FILE ($SIZE)"
    else
        log_info " MongoDB backup failed!"
    fi
}

main() {
    log_info "========== Automated Database Backup =========="
    log_info "Rotation Schedule: $ROTATION"
    
    backup_postgres
    backup_mysql
    backup_mongodb
    
    log_info "Backup operations completed. Report saved to $REPORT_FILE"
    echo "============================================="
}

main "$@"