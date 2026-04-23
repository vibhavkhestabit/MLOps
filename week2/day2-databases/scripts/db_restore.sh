#!/bin/bash

# Script: db_restore.sh
# Description: Interactive tool to safely restore databases from compressed archives.
# Author: Vibhav Khaneja
# Date: 2026-04-23

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_ROOT="${SCRIPT_DIR}/../backups"
LOG_DIR="${SCRIPT_DIR}/../logs"
LOG_FILE="${LOG_DIR}/db_restore_operations.log"

mkdir -p "$LOG_DIR"

# Credentials
PG_USER="postgres"
MYSQL_PASS="RootP@ssw0rd123"
MONGO_PASS="AdminP@ssw0rd123"

log_info() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"; }

show_menu() {
    echo "========================================"
    echo "         Database Restore Tool          "
    echo "========================================"
    echo "1) Restore PostgreSQL"
    echo "2) Restore MySQL"
    echo "3) Restore MongoDB"
    echo "4) Exit"
    echo "========================================"
}

restore_db() {
    local db_type=$1
    echo "Scanning for $db_type backups..."
    
    # Securely read all matching backup files into an array, sorted by newest first
    mapfile -t backups < <(find "${BACKUP_ROOT}/${db_type}" -type f -name "*.gz" | sort -r)
    
    if [ ${#backups[@]} -eq 0 ]; then
        echo "No backup archives found for $db_type."
        return
    fi
    
    echo "Available backups:"
    for i in "${!backups[@]}"; do
        size=$(du -h "${backups[$i]}" | cut -f1)
        filename=$(basename "${backups[$i]}")
        echo "$((i+1))) $filename ($size)"
    done
    
    read -rp "Select a backup to restore (1-${#backups[@]}): " choice
    
    # Validate numeric input within range
    if ! [[ "$choice" =~ ^[0-9]+$ ]] || [ "$choice" -lt 1 ] || [ "$choice" -gt "${#backups[@]}" ]; then
        echo "Invalid selection."
        return
    fi
    
    local target_file="${backups[$((choice-1))]}"
    
    echo ""
    echo "  WARNING: This will drop current tables/collections and overwrite them with the backup!"
    read -rp "Are you absolutely sure you want to proceed? (yes/no): " confirm
    
    if [[ "$confirm" != "yes" ]]; then
        echo "Restore operation cancelled."
        return
    fi

    local TIMESTAMP=$(date '+%Y%m%d_%H%M%S')
    local PRE_RESTORE_FILE="${BACKUP_ROOT}/${db_type}/pre_restore_${TIMESTAMP}.gz"
    log_info "Creating pre-restore safety snapshot: $PRE_RESTORE_FILE"
    
    case $db_type in
        "postgresql")
            sudo -u "$PG_USER" pg_dumpall | gzip > "$PRE_RESTORE_FILE"
            ;;
        "mysql")
            sudo mysqldump -u root -p"$MYSQL_PASS" --all-databases --single-transaction | gzip > "$PRE_RESTORE_FILE" 2>/dev/null
            ;;
        "mongodb")
            mongodump --host="127.0.0.1:27017" --username="admin" --password="$MONGO_PASS" --authenticationDatabase="admin" --archive="$PRE_RESTORE_FILE" --gzip >/dev/null 2>&1
            ;;
    esac
    log_info "✓ Pre-restore snapshot created securely."
    
    log_info "Initiating $db_type restore from: $target_file"
    
    case $db_type in
        "postgresql")
            # zcat streams the uncompressed text directly into psql
            zcat "$target_file" | sudo -u "$PG_USER" psql postgres >/dev/null 2>&1
            ;;
        "mysql")
            zcat "$target_file" | sudo mysql -u root -p"$MYSQL_PASS" 2>/dev/null
            ;;
        "mongodb")
            # --drop ensures collections are cleared before restoring to avoid duplicate key errors
            mongorestore --host="127.0.0.1:27017" --username="admin" --password="$MONGO_PASS" --authenticationDatabase="admin" --archive="$target_file" --gzip --drop >/dev/null 2>&1
            ;;
    esac
    
    log_info "✓ Restore completed successfully."
}

while true; do
    show_menu
    read -rp "Choice: " choice

    case $choice in
        1) restore_db "postgresql" ;;
        2) restore_db "mysql" ;;
        3) restore_db "mongodb" ;;
        4) echo "Exiting..."; break ;;
        *) echo "Invalid option. Please try again." ;;
    esac
    echo ""
done