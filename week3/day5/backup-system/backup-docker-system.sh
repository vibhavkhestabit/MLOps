#!/bin/bash

BACKUP_ROOT="./backups"
DATE=$(date +%Y%m%d-%H%M%S)
BACKUP_DIR="$BACKUP_ROOT/$DATE"

mkdir -p "$BACKUP_DIR"/{volumes,configs}

echo "========== Docker Backup =========="
echo "Started: $(date)"
echo "Directory: $BACKUP_DIR"
echo "==================================="

# Backup volumes
echo "Backing up volumes..."

docker volume ls -q | while read VOLUME; do

  echo " - $VOLUME"

  docker run --rm \
    -v "$VOLUME":/source:ro \
    -v "$(pwd)/$BACKUP_DIR/volumes":/backup \
    alpine \
    tar czf "/backup/${VOLUME}.tar.gz" -C /source .

done

# Backup compose files
echo "Backing up compose configs..."

find .. -name "docker-compose*.yml" | \
tar czf "$BACKUP_DIR/configs/docker-compose-files.tar.gz" -T -

# Create manifest
cat > "$BACKUP_DIR/manifest.txt" << EOF
Docker Backup Manifest

Date: $(date)

Volumes:
$(docker volume ls)

Containers:
$(docker ps -a)

Images:
$(docker images)

EOF

echo "==================================="
echo "Backup completed successfully!"
echo "==================================="
