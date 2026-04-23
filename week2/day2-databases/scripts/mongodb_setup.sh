#!/bin/bash
set -eo pipefail

# Script: mongodb_setup.sh
# Description: Installs MongoDB 7.0, enables auth, configures WiredTiger, creates users.
# Author: Vibhav Khaneja
# Date: 2026-04-23

readonly EXIT_SUCCESS=0
readonly EXIT_ERROR=1

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="${SCRIPT_DIR}/../logs"
LOG_FILE="${LOG_DIR}/mongodb_setup.log"

mkdir -p "$LOG_DIR"

log_info() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $1" | tee -a "$LOG_FILE"; }
log_error() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $1" | tee -a "$LOG_FILE" >&2; }

main() {
    log_info "========== MongoDB Setup =========="
    
    # 1. Install MongoDB 7.0
    log_info "Adding MongoDB 7.0 repository..."
    curl -fsSL https://www.mongodb.org/static/pgp/server-7.0.asc | sudo gpg -o /usr/share/keyrings/mongodb-server-7.0.gpg --dearmor --yes
    echo "deb [ arch=amd64,arm64 signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] https://repo.mongodb.org/apt/ubuntu jammy/mongodb-org/7.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list > /dev/null
    
    sudo apt-get update > /dev/null 2>&1
    sudo apt-get install -y mongodb-org > /dev/null 2>&1
    log_info "✓ MongoDB 7.0 installed"

    # Start temporarily without auth to create admin
    sudo systemctl enable mongod > /dev/null 2>&1
    sudo systemctl start mongod
    sleep 5 # Wait for daemon to initialize

    # 2. Create Users
    log_info "Creating admin and application users..."
    mongosh admin --eval 'db.createUser({user: "admin", pwd: "AdminP@ssw0rd123", roles: [{role: "userAdminAnyDatabase", db: "admin"}, {role: "readWriteAnyDatabase", db: "admin"}]})' > /dev/null 2>&1
    mongosh appdb --eval 'db.createUser({user: "appuser", pwd: "AppP@ssw0rd123", roles: [{role: "readWrite", db: "appdb"}]})' > /dev/null 2>&1
    log_info "✓ Users 'admin' and 'appuser' created. Database 'appdb' initialized."

    # 3. Configure mongod.conf
    local MONGO_CONF="/etc/mongod.conf"
    log_info "Optimizing mongod.conf (Enabling Auth, WiredTiger caching)..."
    
    # Enable authorization
    sudo sed -i 's/^#security:/security:\n  authorization: "enabled"/' "$MONGO_CONF"
    
    # Bind to all IPs (required for network access)
    sudo sed -i 's/bindIp: 127.0.0.1/bindIp: 0.0.0.0/' "$MONGO_CONF"
    
    # Configure WiredTiger cache (Set to 1GB for this exercise)
    sudo sed -i '/engine:/a \  wiredTiger:\n    engineConfig:\n      cacheSizeGB: 1' "$MONGO_CONF"
    
    sudo cp "$MONGO_CONF" "${SCRIPT_DIR}/../configs/mongod.conf.optimized"
    
    # 4. Restart to enforce changes
    sudo systemctl restart mongod
    log_info "✓ Configuration applied and service restarted with Authentication ENFORCED."

    # 5. Verification
    sleep 3
    if mongosh "mongodb://appuser:AppP@ssw0rd123@127.0.0.1:27017/appdb" --eval 'db.runCommand({ connectionStatus: 1 })' > /dev/null 2>&1; then
        log_info "✓ Connection test: SUCCESSFUL"
        log_info "Status: Ready for production"
    else
        log_error "Connection test FAILED."
        exit $EXIT_ERROR
    fi

    echo "==================================="
    exit $EXIT_SUCCESS
}

main "$@"