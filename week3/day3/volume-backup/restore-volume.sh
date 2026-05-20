#!/bin/bash

if [ $# -ne 2 ]; then
    echo "Usage:"
    echo "./restore-volume.sh <backup-file> <target-volume>"
    exit 1
fi

BACKUP_FILE=$1
TARGET_VOLUME=$2

echo "Creating target volume..."
docker volume create "$TARGET_VOLUME"

echo "Restoring backup..."

docker run --rm \
-v "$TARGET_VOLUME":/restore \
-v "$(pwd)/backups":/backup \
alpine \
sh -c "cd /restore && tar xzf /backup/$BACKUP_FILE"

echo "✓ Restore completed into volume: $TARGET_VOLUME"
