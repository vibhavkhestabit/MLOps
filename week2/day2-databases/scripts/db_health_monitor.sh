#!/bin/bash

# Script: db_health_monitor.sh
# Description: Checks health, connections, and storage for all databases.
# Author: Vibhav Khaneja
# Date: 2026-04-23

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="${SCRIPT_DIR}/../logs"
REPORT_FILE="${LOG_DIR}/db_health_$(date '+%Y-%m-%d').log"

mkdir -p "$LOG_DIR"
touch "$REPORT_FILE"

# Credentials
PG_USER="postgres"
MYSQL_PASS="RootP@ssw0rd123"
MONGO_PASS="AdminP@ssw0rd123"

log_info() { echo "[$(date '+%H:%M:%S')] [INFO] $1" | tee -a "$REPORT_FILE"; }
log_alert() { echo "[$(date '+%H:%M:%S')] [ALERT] 🚨 $1" | tee -a "$REPORT_FILE"; }

check_disk_usage() {
    # Get the disk usage percentage of the root partition
    local disk_usage=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
    log_info "System Disk Usage: ${disk_usage}%"
    
    if [ "$disk_usage" -gt 85 ]; then
        log_alert "Disk usage exceeded 85% threshold! Currently at ${disk_usage}%"
    fi
}

check_postgres() {
    log_info "--- PostgreSQL Health ---"
    if systemctl is-active --quiet postgresql; then
        log_info "Service: UP"
        
        # Check connections
        local active_conn=$(sudo -u "$PG_USER" psql -t -c "SELECT count(*) FROM pg_stat_activity;" | xargs)
        local max_conn=$(sudo -u "$PG_USER" psql -t -c "SHOW max_connections;" | xargs)
        log_info "Connections: $active_conn / $max_conn"
        
        # Calculate 80% threshold
        local threshold=$(echo "$max_conn * 0.8" | bc | cut -d. -f1)
        if [ "$active_conn" -gt "$threshold" ]; then
            log_alert "PostgreSQL connections exceeded 80% threshold!"
        fi
        
        # Check DB Size
        local db_size=$(sudo -u "$PG_USER" psql -t -c "SELECT pg_size_pretty(pg_database_size('testdb'));" | xargs)
        log_info "Database 'testdb' Size: $db_size"
    else
        log_alert "PostgreSQL Service is DOWN!"
    fi
}

check_mysql() {
    log_info "--- MySQL Health ---"
    if systemctl is-active --quiet mysql; then
        log_info "Service: UP"
        
        if mysqladmin -u root -p"$MYSQL_PASS" ping -s >/dev/null 2>&1; then
            # Check connections
            local active_conn=$(mysql -u root -p"$MYSQL_PASS" -N -e "SHOW STATUS LIKE 'Threads_connected';" 2>/dev/null | awk '{print $2}')
            local max_conn=$(mysql -u root -p"$MYSQL_PASS" -N -e "SHOW VARIABLES LIKE 'max_connections';" 2>/dev/null | awk '{print $2}')
            log_info "Connections: $active_conn / $max_conn"
            
            local threshold=$(echo "$max_conn * 0.8" | bc | cut -d. -f1)
            if [ "$active_conn" -gt "$threshold" ]; then
                log_alert "MySQL connections exceeded 80% threshold!"
            fi
        else
            log_alert "MySQL service is running but cannot connect (authentication or socket issue)."
        fi
    else
        log_alert "MySQL Service is DOWN!"
    fi
}

check_mongodb() {
    log_info "--- MongoDB Health ---"
    if systemctl is-active --quiet mongod; then
        log_info "Service: UP"
        
        if mongosh admin -u admin -p "$MONGO_PASS" --eval "db.serverStatus().ok" --quiet >/dev/null 2>&1; then
            local conn_json=$(mongosh admin -u admin -p "$MONGO_PASS" --eval "JSON.stringify(db.serverStatus().connections)" --quiet 2>/dev/null)
            local active_conn=$(echo "$conn_json" | grep -o '"current":[0-9]*' | cut -d: -f2)
            log_info "Active Connections: $active_conn"
            
            # Simple size check
            local db_stats=$(mongosh appdb -u admin -p "$MONGO_PASS" --eval "db.stats().dataSize" --quiet 2>/dev/null)
            # Convert bytes to MB roughly
            local size_mb=$((db_stats / 1024 / 1024))
            log_info "Database 'appdb' Data Size: ${size_mb}MB"
        else
            log_alert "MongoDB service is running but cannot connect via mongosh."
        fi
    else
        log_alert "MongoDB Service is DOWN!"
    fi
}

main() {
    echo "========================================"
    echo "    Database Health Check Triggered     "
    echo "========================================"
    check_disk_usage
    check_postgres
    check_mysql
    check_mongodb
    echo "========================================"
}

main