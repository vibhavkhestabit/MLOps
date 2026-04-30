#!/bin/bash
set -e

echo "=========================================="
echo "Creating Systemd Services for Laravel..."
echo "=========================================="

CURRENT_USER=$USER
APP_DIR="/home/$CURRENT_USER/MLOps-Training/week2/day4-applications/laravel-mysql-api"

# 1. Setup 3 Laravel API Instances
for PORT in 8000 8001 8002; do
  echo "-> Configuring laravel-app-$PORT.service"
  cat <<EOF | sudo tee /etc/systemd/system/laravel-app-$PORT.service > /dev/null
[Unit]
Description=Laravel API Instance on Port $PORT
After=network.target mysql.service

[Service]
Type=simple
User=$CURRENT_USER
WorkingDirectory=$APP_DIR
ExecStart=/usr/bin/php artisan serve --host=127.0.0.1 --port=$PORT
Restart=always
RestartSec=10
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=laravel-app-$PORT

[Install]
WantedBy=multi-user.target
EOF
done

# 2. Setup Laravel Queue Worker
echo "-> Configuring laravel-worker.service"
cat <<EOF | sudo tee /etc/systemd/system/laravel-worker.service > /dev/null
[Unit]
Description=Laravel Queue Worker
After=network.target mysql.service

[Service]
Type=simple
User=$CURRENT_USER
WorkingDirectory=$APP_DIR
ExecStart=/usr/bin/php artisan queue:work --sleep=3 --tries=3 --max-time=3600
Restart=always
RestartSec=10
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=laravel-worker

[Install]
WantedBy=multi-user.target
EOF

# 3. Reload Systemd and Start Services
echo "Reloading systemd daemon..."
sudo systemctl daemon-reload

echo "Starting and enabling all services..."
for PORT in 8000 8001 8002; do
    sudo systemctl enable --now laravel-app-$PORT.service
done
sudo systemctl enable --now laravel-worker.service

echo "=========================================="
echo "[SUCCESS] Laravel Stack 2 Services are LIVE!"
echo "=========================================="