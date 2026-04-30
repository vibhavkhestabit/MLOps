#!/bin/bash
set -euo pipefail

echo "================================================"
echo "Initializing MySQL Master-Slave Replication..."
echo "================================================"

# 1. Create the replication user on the Master database
echo "Configuring Master Node (Port 3306)..."
sudo mysql -u root -p'RootP@ssw0rd123' -e "
CREATE USER IF NOT EXISTS 'replication'@'%' IDENTIFIED BY 'ReplicaP@ssw0rd!';
GRANT REPLICATION SLAVE ON *.* TO 'replication'@'%';
FLUSH PRIVILEGES;
"

# 2. Extract the current Master Log File and Position
echo "Extracting Master Status..."
MASTER_STATUS=$(sudo mysql -u root -p'RootP@ssw0rd123' -e "SHOW MASTER STATUS\G")
MASTER_LOG_FILE=$(echo "$MASTER_STATUS" | grep File | awk '{print $2}')
MASTER_LOG_POS=$(echo "$MASTER_STATUS" | grep Position | awk '{print $2}')

echo "-> Master Log File: $MASTER_LOG_FILE"
echo "-> Master Position: $MASTER_LOG_POS"

echo "================================================"
echo "[SUCCESS] Master Node Configured for Replication."
echo "Ready for Slave Nodes to connect."
echo "================================================"