#!/bin/bash

BACKUP_PATH=$1
VOLUME_NAME=$2

if [ -z "$BACKUP_PATH" ] || [ -z "$VOLUME_NAME" ]; then
  echo "Usage:"
  echo "./restore-volume.sh <backup-file> <volume-name>"
  exit 1
fi

echo "==================================="
echo "Restoring volume: $VOLUME_NAME"
echo "Backup file: $BACKUP_PATH"
echo "==================================="

docker volume create $VOLUME_NAME

docker run --rm \
  -v $VOLUME_NAME:/restore \
  -v $(pwd):/backup \
  alpine \
  sh -c "tar xzf /backup/$BACKUP_PATH -C /restore"

echo "==================================="
echo "Restore completed!"
echo "==================================="
