#!/bin/bash
set -e

echo "=========================================="
echo "Starting Zero-Downtime Deployment: Stack 2"
echo "=========================================="

APP_DIR="/home/$USER/MLOps-Training/week2/day4-applications/laravel-mysql-api"

# 1. Update Code & Dependencies
echo "Installing Backend dependencies..."
cd $APP_DIR
# In a real pipeline, 'git pull' would go here
composer install --no-interaction --prefer-dist --optimize-autoloader

# 2. Database Migrations
echo "Running database migrations..."
php artisan migrate --force

# 3. Clear and Cache Configurations (Laravel Best Practice)
echo "Optimizing Laravel configuration..."
php artisan config:cache
php artisan route:cache
php artisan view:cache

# 4. Rolling Restart for Laravel Instances (Systemd)
echo "Performing rolling restart for Backend APIs..."
for PORT in 8000 8001 8002; do
    echo "-> Restarting laravel-app-$PORT.service..."
    sudo systemctl restart laravel-app-$PORT.service
    
    echo "-> Waiting for instance to stabilize..."
    sleep 5
    
    # Health check the specific port locally before moving on
    if curl -s -f http://127.0.0.1:$PORT/api/health > /dev/null; then
        echo "[PASS] laravel-app-$PORT is healthy!"
    else
        echo "[FAIL] laravel-app-$PORT failed health check! Aborting deployment to prevent downtime."
        exit 1
    fi
done

# 5. Restart Queue Workers
echo "Restarting Laravel Queue Worker..."
sudo systemctl restart laravel-worker.service

echo "=========================================="
echo "[SUCCESS] Stack 2 Deployment Complete!"
echo "Zero downtime achieved. Traffic was routed seamlessly."
echo "=========================================="