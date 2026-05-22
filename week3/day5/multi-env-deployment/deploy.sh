#!/bin/bash

ENV=$1

if [ -z "$ENV" ]; then
  echo "Usage: ./deploy.sh [dev|staging|prod]"
  exit 1
fi

case $ENV in
  dev)
    PROJECT="development"
    COMPOSE_FILE="docker-compose.dev.yml"
    ;;

  staging)
    PROJECT="staging"
    COMPOSE_FILE="docker-compose.staging.yml"
    ;;

  prod)
    PROJECT="production"
    COMPOSE_FILE="docker-compose.prod.yml"
    ;;

  *)
    echo "Invalid environment"
    exit 1
    ;;
esac

echo "Deploying $ENV environment..."

docker compose \
-p $PROJECT \
-f docker-compose.yml \
-f $COMPOSE_FILE \
up --build -d

echo "$ENV deployment completed!"