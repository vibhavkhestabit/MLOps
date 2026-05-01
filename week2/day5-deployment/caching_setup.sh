#!/bin/bash
# ==============================================================================
# Script Name: caching_setup.sh
# Description: Installs and configures Redis and Nginx caching layers.
# Author: Vibhav Khaneja
# Date: 2026-05-01
# ==============================================================================

LOG_DIR="/home/$USER/MLOps-Training/week2/day5-deployment/logs"
mkdir -p "$LOG_DIR"
LOG_FILE="$LOG_DIR/caching_setup_$(date +%Y%m%d).log"

echo "========================================================" | tee -a "$LOG_FILE"
echo "Starting Caching Optimization Setup - $(date +'%Y-%m-%d %H:%M:%S')" | tee -a "$LOG_FILE"
echo "========================================================" | tee -a "$LOG_FILE"

# 1. Install Redis
echo "-> Installing Redis Server..." | tee -a "$LOG_FILE"
sudo apt-get update > /dev/null 2>&1
sudo apt-get install redis-server -y > /dev/null 2>&1

# 2. Configure Redis for Caching
echo "-> Configuring Redis Eviction Policies..." | tee -a "$LOG_FILE"
# We want Redis to act as a cache, not a persistent database.
# If it runs out of memory, it should delete the oldest, least-used data.
sudo sed -i 's/# maxmemory <bytes>/maxmemory 256mb/' /etc/redis/redis.conf
sudo sed -i 's/# maxmemory-policy noeviction/maxmemory-policy allkeys-lru/' /etc/redis/redis.conf

echo "-> Restarting Redis..." | tee -a "$LOG_FILE"
sudo systemctl restart redis-server
sudo systemctl enable redis-server

if systemctl is-active --quiet redis-server; then
    echo "[PASS] Redis is installed and running." | tee -a "$LOG_FILE"
else
    echo "[FAIL] Redis failed to start." | tee -a "$LOG_FILE"
    exit 1
fi

# 3. Create Nginx Cache Directory
echo "-> Setting up Nginx FastCGI/Proxy Cache directories..." | tee -a "$LOG_FILE"
sudo mkdir -p /var/cache/nginx
sudo chown -R www-data:www-data /var/cache/nginx

echo "========================================================" | tee -a "$LOG_FILE"
echo "[SUCCESS] Base caching infrastructure is deployed!" | tee -a "$LOG_FILE"
echo "To implement application-level caching, you must integrate"
echo "Redis libraries (e.g., aioredis, node-redis) into your source code."
echo "========================================================" | tee -a "$LOG_FILE"