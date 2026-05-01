#!/bin/bash
# ==============================================================================
# Script Name: performance_optimizer.sh
# Description: Applies system-level and Nginx optimizations for high throughput.
# Author: Vibhav Khaneja
# Date: 2026-05-01
# ==============================================================================

LOG_DIR="/home/$USER/MLOps-Training/week2/day5-deployment/logs"
mkdir -p "$LOG_DIR"
OPT_LOG="$LOG_DIR/optimization_$(date +%Y%m%d).log"

echo "========================================================" | tee -a "$OPT_LOG"
echo "Executing System Performance Optimization - $(date +'%Y-%m-%d %H:%M:%S')" | tee -a "$OPT_LOG"
echo "========================================================" | tee -a "$OPT_LOG"

# 1. Kernel Parameter Tuning (sysctl)
echo "-> Tuning Kernel Parameters (TCP networking and File Descriptors)..." | tee -a "$OPT_LOG"
cat <<EOF | sudo tee /etc/sysctl.d/99-devops-performance.conf > /dev/null
# Increase system file descriptor limit
fs.file-max = 1000000

# Optimize TCP connection handling for high throughput load balancers
net.ipv4.tcp_tw_reuse = 1
net.ipv4.ip_local_port_range = 1024 65000
net.core.somaxconn = 65535
net.ipv4.tcp_max_syn_backlog = 65535
EOF

sudo sysctl -p /etc/sysctl.d/99-devops-performance.conf >> "$OPT_LOG" 2>&1
echo "[PASS] Kernel parameters optimized." | tee -a "$OPT_LOG"

# 2. Nginx Advanced Tuning
echo "-> Tuning Nginx Worker Limits..." | tee -a "$OPT_LOG"
# Update worker_connections in the main Nginx config using sed
sudo sed -i 's/worker_connections.*/worker_connections 4096;/' /etc/nginx/nginx.conf
sudo systemctl reload nginx
echo "[PASS] Nginx worker_connections increased to 4096." | tee -a "$OPT_LOG"

echo "========================================================" | tee -a "$OPT_LOG"
echo "[SUCCESS] Performance Optimizations Applied Successfully!" | tee -a "$OPT_LOG"
echo "========================================================" | tee -a "$OPT_LOG"