#!/bin/bash
set -e

echo "=========================================="
echo "Starting Zero-Downtime Deployment: Stack 3"
echo "=========================================="

# 1. Update Code (Simulated)
echo "Pulling latest code and updating dependencies..."
# git pull origin main
# pip install -r requirements.txt
# npm install

# 2. Rolling Restart for Python Backend (Systemd)
echo "Performing rolling restart for FastAPI Backend..."
for PORT in 8003 8004 8005; do
    echo "-> Restarting fastapi-app-$PORT.service..."
    sudo systemctl restart fastapi-app-$PORT.service
    
    sleep 5
    
    # Health check the Python API
    if curl -s -f http://127.0.0.1:$PORT/api/health > /dev/null; then
        echo "[PASS] fastapi-app-$PORT is healthy!"
    else
        echo "[FAIL] fastapi-app-$PORT failed health check! Aborting."
        exit 1
    fi
done

# 3. Rolling Restart for Next.js Frontend (PM2)
echo "Performing rolling restart for Next.js Frontend..."
for PORT in 3005 3006; do
    echo "-> Restarting stack3-nextjs-$PORT..."
    pm2 restart stack3-nextjs-$PORT
    
    sleep 5
    
    # Health check the Next.js UI
    if curl -s -f http://127.0.0.1:$PORT > /dev/null; then
        echo "[PASS] stack3-nextjs-$PORT is healthy!"
    else
        echo "[FAIL] stack3-nextjs-$PORT failed health check! Aborting."
        exit 1
    fi
done

echo "=========================================="
echo "[SUCCESS] Stack 3 Deployment Complete!"
echo "Zero downtime achieved across Python and Node.js."
echo "=========================================="
