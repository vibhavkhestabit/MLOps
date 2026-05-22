#!/bin/bash

CURRENT_ENV=$(docker ps --filter "name=app-" --format "{{.Names}}" | grep -o "blue\|green" | head -1)

if [ "$CURRENT_ENV" == "blue" ]; then
  NEW_ENV="green"
else
  NEW_ENV="blue"
fi

echo "Current environment: $CURRENT_ENV"
echo "Deploying to: $NEW_ENV"

# Deploy new environment
docker compose -f docker-compose.$NEW_ENV.yml up --build -d

echo "Waiting for health check..."
sleep 5

# Health check
HEALTH=$(docker exec app-$NEW_ENV wget -qO- http://localhost:3000/health)
if [[ "$HEALTH" != "OK" ]]; then
  echo "Health check failed!"
  docker compose -f docker-compose.$NEW_ENV.yml down
  exit 1
fi

echo "Health check passed."

# Switch nginx config
sed -i "s/server app-$CURRENT_ENV/# server app-$CURRENT_ENV/" nginx.conf
sed -i "s/# server app-$NEW_ENV/server app-$NEW_ENV/" nginx.conf

# Reload nginx
docker exec nginx nginx -s reload

echo "Traffic switched to $NEW_ENV"
echo "Old environment ($CURRENT_ENV) still running for rollback"