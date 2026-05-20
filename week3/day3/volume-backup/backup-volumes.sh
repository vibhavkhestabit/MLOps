#!/bin/bash

BACKUP_DIR="$(pwd)/backups"
DATE=$(date +%Y%m%d-%H%M%S)

mkdir -p "$BACKUP_DIR"

VOLUMES=$(docker volume ls -q)

echo "Starting Docker volume backup..."
echo "Backup directory: $BACKUP_DIR"
echo

for VOLUME in $VOLUMES; do
    echo "Backing up volume: $VOLUME"

    docker run --rm \
    -v "$VOLUME":/source:ro \
    -v "$BACKUP_DIR":/backup \
    alpine \
    tar czf "/backup/${VOLUME}-${DATE}.tar.gz" -C /source .

    echo "✓ Backup completed: ${VOLUME}-${DATE}.tar.gz"
    echo
done

echo "All backups completed."

echo "Cleaning backups older than 7 days..."
find "$BACKUP_DIR" -name "*.tar.gz" -mtime +7 -delete

echo "Cleanup complete."
