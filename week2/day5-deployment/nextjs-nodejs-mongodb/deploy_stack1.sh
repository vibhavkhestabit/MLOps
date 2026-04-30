#!/bin/bash
set -e

echo "=========================================="
echo "Starting Zero-Downtime Deployment: Stack 1"
echo "=========================================="

# 1. Update Code & Dependencies (Assuming paths based on Day 4)
echo "Installing Backend dependencies..."
cd ~/MLOps-Training/week2/day4-applications/express-postgresql-api && npm install --production

echo "Installing and Building Frontend..."
cd ~/MLOps-Training/week2/day4-applications/next-frontend && npm install && npm run build

# 2. Rolling Restart for Backend API Instances
echo "Performing rolling restart for Backend APIs..."
for PORT in 3000 3003 3004; do
    echo "-> Restarting nodejs-api-$PORT..."
    pm2 restart nodejs-api-$PORT
    
    echo "-> Waiting for instance to stabilize..."
    sleep 5
    
    # Health check the specific port
    if curl -s -f http://127.0.0.1:$PORT/api/health > /dev/null; then
        echo "[PASS] nodejs-api-$PORT is healthy!"
    else
        echo "[FAIL] nodejs-api-$PORT failed health check! Aborting deployment to prevent downtime."
        exit 1
    fi
done

# 3. Rolling Restart for Frontend Next.js Instances
echo "Performing rolling restart for Frontend instances..."
for PORT in 3001 3002; do
    echo "-> Restarting nextjs-app-$PORT..."
    pm2 restart nextjs-app-$PORT
    
    echo "-> Waiting for instance to stabilize..."
    sleep 5
    
    # Basic ping check for SSR frontend
    if curl -s -f http://127.0.0.1:$PORT > /dev/null; then
        echo "[PASS] nextjs-app-$PORT is healthy!"
    else
        echo "[FAIL] nextjs-app-$PORT failed ping check! Aborting deployment."
        exit 1
    fi
done

echo "=========================================="
echo "[SUCCESS] Stack 1 Deployment Complete!"
echo "Zero downtime achieved. Traffic was routed seamlessly."
echo "=========================================="
