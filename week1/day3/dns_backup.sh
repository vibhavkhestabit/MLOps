#!/bin/bash
set -euo pipefail

# Script: dns_backup.sh
# Description: Compresses and securely archives all BIND DNS configurations and zone files.
# Author: Vibhav Khaneja

BACKUP_DIR="/backup/dns"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
ARCHIVE_NAME="dns_infrastructure_${TIMESTAMP}.tar.gz"
ARCHIVE_PATH="${BACKUP_DIR}/${ARCHIVE_NAME}"

echo "Starting DNS Disaster Recovery Backup..."

# 1. Create the secure backup vault
sudo mkdir -p "$BACKUP_DIR"
sudo chmod 700 "$BACKUP_DIR"

# 2. Compress the entire BIND directory into a single archive
# -c (create), -z (gzip compress), -f (file)
echo "-> Archiving /etc/bind..."
sudo tar -czf "$ARCHIVE_PATH" /etc/bind 2>/dev/null

# 3. Secure the archive (Only root can read it)
sudo chmod 600 "$ARCHIVE_PATH"

# 4. Integrity Check
if sudo tar -tzf "$ARCHIVE_PATH" >/dev/null 2>&1; then
    echo "-> Archive [PASS]: Backup successfully verified."
else
    echo "-> Archive [FAIL]: Backup corrupted!"
    exit 1
fi

# 5. Retention Policy (Clean up backups older than 30 days)
echo "-> Enforcing 30-day retention policy..."
sudo find "$BACKUP_DIR" -name "dns_infrastructure_*.tar.gz" -type f -mtime +30 -exec rm {} \;

echo "=========================================="
echo "[SUCCESS] Backup secured at: $ARCHIVE_PATH"