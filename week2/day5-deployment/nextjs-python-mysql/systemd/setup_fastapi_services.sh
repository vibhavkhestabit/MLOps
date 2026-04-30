#!/bin/bash
set -e

echo "=========================================="
echo "Creating Systemd Services for FastAPI..."
echo "=========================================="

CURRENT_USER=$USER
APP_DIR="/home/$CURRENT_USER/MLOps-Training/week2/day4-applications/fastapi-mysql-api"
VENV_PATH="/home/$CURRENT_USER/MLOps-Training/week2/day4-applications/fastapi-mysql-api/venv/bin"

# Ensure the app directory exists
if [ ! -d "$APP_DIR" ]; then
    echo "ERROR: Could not find FastAPI app at $APP_DIR"
    exit 1
fi

# 1. Setup 3 FastAPI Instances
for PORT in 8003 8004 8005; do
  echo "-> Configuring fastapi-app-$PORT.service"
  cat <<EOF | sudo tee /etc/systemd/system/fastapi-app-$PORT.service > /dev/null
[Unit]
Description=FastAPI Instance on Port $PORT
After=network.target mysql.service

[Service]
Type=simple
User=$CURRENT_USER
WorkingDirectory=$APP_DIR
Environment="PATH=$VENV_PATH:/usr/local/bin:/usr/bin:/bin"
EnvironmentFile=$APP_DIR/.env
ExecStart=$VENV_PATH/uvicorn main:app --host 127.0.0.1 --port $PORT
Restart=always
RestartSec=10
StandardOutput=syslog
StandardError=syslog
SyslogIdentifier=fastapi-app-$PORT

[Install]
WantedBy=multi-user.target
EOF
done

# 2. Reload Systemd and Start Services
echo "Reloading systemd daemon..."
sudo systemctl daemon-reload

echo "Starting and enabling FastAPI services..."
for PORT in 8003 8004 8005; do
    sudo systemctl enable --now fastapi-app-$PORT.service
done

echo "=========================================="
echo "[SUCCESS] FastAPI Backend Fleet is LIVE!"
echo "=========================================="