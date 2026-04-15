#!/bin/bash
set -euo pipefail

# Script: backup_system.sh
# Description: Compresses critical system directories and manages retention.
# Author: Vibhav Khaneja

# 1. Configuration Variables
BACKUP_DEST="/backup"
TIMESTAMP=$(date '+%Y-%m-%d_%H-%M-%S')
ARCHIVE_NAME="system_backup_${TIMESTAMP}.tar.gz"
ARCHIVE_PATH="${BACKUP_DEST}/${ARCHIVE_NAME}"

# Directories we want to save
SOURCE_DIRS="/etc /home/Raj /home/Shubh /home/Vaishanavi"

# 2. Ensure backup directory exists
if [[ ! -d "$BACKUP_DEST" ]]; then
    echo "Creating backup destination at $BACKUP_DEST..."
    mkdir -p "$BACKUP_DEST"
fi

# 3. Create the Backup (The tar command)
echo "Starting system backup. This may take a moment..."
# -c (create), -z (gzip compress), -f (file)
tar -czf "$ARCHIVE_PATH" $SOURCE_DIRS 2>/dev/null

# 4. Security: Lock down the backup file
# 600 means ONLY the owner (root) can read or write this file. 
chmod 600 "$ARCHIVE_PATH"
echo "Backup created and secured: $ARCHIVE_PATH"

# 5. Verify Archive Integrity
# -t (test/list), -z (gzip), -f (file)
if tar -tzf "$ARCHIVE_PATH" > /dev/null 2>&1; then
    echo "Integrity Check: PASSED. Archive is healthy."
    logger -t SYSTEM_BACKUP "Backup successful: $ARCHIVE_NAME"
else
    echo "Integrity Check: FAILED! Archive may be corrupted." >&2
    logger -t SYSTEM_BACKUP "Backup FAILED: $ARCHIVE_NAME"
    exit 1
fi

# 6. Retention Policy: Delete backups older than 7 days
echo "Cleaning up old backups (older than 7 days)..."
find "$BACKUP_DEST" -type f -name "system_backup_*.tar.gz" -mtime +7 -exec rm {} \;

echo "Backup process completed successfully."