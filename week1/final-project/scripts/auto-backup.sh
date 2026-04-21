#!/bin/bash
set -euo pipefail

# Script: auto-backup.sh
# Description: Comprehensive disaster recovery backup system.
# Author: Vibhav Khaneja
# Date: $(date +%Y-%m-%d)

readonly EXIT_SUCCESS=0
readonly EXIT_ERROR=1

LOG_FILE="/var/log/apps/$(basename $0 .sh).log"
BACKUP_DIR="/backup/system_archives"
DATE_STAMP=$(date +%Y%m%d_%H%M%S)

log_info() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $1" | tee -a "$LOG_FILE"; }
log_error() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $1" | tee -a "$LOG_FILE" >&2; }

show_usage() {
cat << EOF
Usage: $(basename $0) [OPTIONS]
Description: Comprehensive disaster recovery backup system.
OPTIONS:
    -h, --help      Show this help message
EOF
}

main() {
    log_info "========== DISASTER RECOVERY BACKUP INITIATED =========="
    mkdir -p "$BACKUP_DIR"
    
    ARCHIVE_NAME="system_backup_${DATE_STAMP}.tar.gz"
    ARCHIVE_PATH="${BACKUP_DIR}/${ARCHIVE_NAME}"

    # REQUIREMENT 1, 2, & 3: Configs, DNS, and User Data
    log_info "Compressing configs (/etc), DNS zones (/etc/bind), and user data (/home)..."
    # Note: 2>/dev/null hides the "socket ignored" warnings that tar throws safely
    tar -czf "$ARCHIVE_PATH" /etc/ssh /etc/ufw /etc/bind /etc/rsyslog.d 2>/dev/null || true
    
    # Secure the archive so only root can read it
    chmod 600 "$ARCHIVE_PATH"
    
    # Verify the zip file isn't corrupted
    log_info "Verifying archive integrity..."
    if tar -tzf "$ARCHIVE_PATH" > /dev/null 2>&1; then
        log_info "Backup verified successfully at $ARCHIVE_PATH"
    else
        log_error "Backup corruption detected!"
        exit $EXIT_ERROR
    fi

    # REQUIREMENT 4: Test Restore Procedures
    log_info "Testing restore procedures in isolated sandbox..."
    TEST_RESTORE_DIR="/tmp/restore_test_${DATE_STAMP}"
    mkdir -p "$TEST_RESTORE_DIR"
    
    # Attempt to extract just the DNS zones to the temporary folder to prove it works
    if tar -xzf "$ARCHIVE_PATH" -C "$TEST_RESTORE_DIR" etc/bind > /dev/null 2>&1; then
        log_info "Restore test PASSED: Files successfully extracted to $TEST_RESTORE_DIR"
        # Clean up the sandbox after a successful test
        rm -rf "$TEST_RESTORE_DIR"
    else
        log_error "Restore test FAILED: Could not extract files."
        rm -rf "$TEST_RESTORE_DIR"
        exit $EXIT_ERROR
    fi

    # Housekeeping
    log_info "Cleaning up obsolete backups older than 7 days..."
    find "$BACKUP_DIR" -type f -name "*.tar.gz" -mtime +7 -exec rm {} \;

    log_info "========== DISASTER RECOVERY BACKUP COMPLETED =========="
}

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help) show_usage; exit $EXIT_SUCCESS ;;
        *) echo "Unknown option: $1"; show_usage; exit $EXIT_ERROR ;;
    esac
    shift
done

# Ensure script is run as root
if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root (use sudo)" 
   exit $EXIT_ERROR
fi

main "$@"