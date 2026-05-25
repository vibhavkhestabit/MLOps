#!/bin/bash

set -e

TIMESTAMP=$(date +%Y%m%d_%H%M%S)

BACKUP_DIR=./backups/$TIMESTAMP

mkdir -p $BACKUP_DIR

echo "Starting backup process..."

# PostgreSQL Backup
echo "Backing up PostgreSQL..."

docker exec postgres pg_dump -U admin users_db > $BACKUP_DIR/users_db.sql

# MongoDB Backup
echo "Backing up MongoDB..."

docker exec mongodb mongodump \
  --uri="mongodb://admin:ADMIN123@localhost:27017/?authSource=admin" \
  --out=/tmp/mongo-backup

docker cp mongodb:/tmp/mongo-backup $BACKUP_DIR/mongodb-backup

# Cleanup temp backup inside container
docker exec mongodb rm -rf /tmp/mongo-backup

# Save compose files
echo "Saving Docker Compose files..."

cp docker-compose.yml $BACKUP_DIR/
cp docker-compose.dev.yml $BACKUP_DIR/
cp docker-compose.prod.yml $BACKUP_DIR/

echo "Backup completed successfully!"
echo "Backup stored at: $BACKUP_DIR"