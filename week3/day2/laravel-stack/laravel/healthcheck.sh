#!/bin/sh
# Custom health check script for Laravel (Exercise 5)

# Use Artisan to verify framework boot and database connectivity
php /var/www/artisan migrate:status > /dev/null 2>&1

if [ $? -eq 0 ]; then
  # exit 0 means success/healthy to Docker
  exit 0
else
  # exit 1 means failure/unhealthy
  exit 1
fi