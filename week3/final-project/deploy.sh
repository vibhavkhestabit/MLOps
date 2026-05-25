#!/bin/bash

set -e

ENVIRONMENT=$1

if [ -z "$ENVIRONMENT" ]; then
  echo "Usage: ./deploy.sh [dev|prod]"
  exit 1
fi

echo "Starting deployment for $ENVIRONMENT environment..."

if [ "$ENVIRONMENT" = "dev" ]; then

  docker compose \
    -f docker-compose.yml \
    -f docker-compose.dev.yml \
    up -d --build

elif [ "$ENVIRONMENT" = "prod" ]; then

  docker compose \
    -f docker-compose.yml \
    -f docker-compose.prod.yml \
    up -d --build

else
  echo "Invalid environment. Use dev or prod."
  exit 1
fi

echo "Deployment completed successfully!"

docker compose ps