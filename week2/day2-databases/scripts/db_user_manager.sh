#!/bin/bash

# Script: db_user_manager.sh
# Description: Interactive centralized control plane for database user management.
# Author: Vibhav Khaneja
# Date: 2026-04-23

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="${SCRIPT_DIR}/../logs"
LOG_FILE="${LOG_DIR}/db_user_operations.log"

mkdir -p "$LOG_DIR"

# Note: Hardcoding admin passwords here to link with our previous setup scripts.
# In a real production environment, these would be pulled from a secure vault (like HashiCorp Vault) or ENV vars.
PG_ADMIN="postgres"
MYSQL_ROOT_PASS="RootP@ssw0rd123"
MONGO_ADMIN_PASS="AdminP@ssw0rd123"

log_operation() { 
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

show_menu() {
    echo "========================================"
    echo "         Database User Manager          "
    echo "========================================"
    echo "1) Create PostgreSQL user"
    echo "2) Create MySQL user"
    echo "3) Create MongoDB user"
    echo "4) List all database users"
    echo "5) Exit"
    echo "========================================"
}

create_pg_user() {
    read -rp "Enter new username: " username
    read -rsp "Enter new password: " password; echo
    read -rp "Enter database name: " dbname
    read -rp "Grant privileges? (full/read): " privs

    sudo -u "$PG_ADMIN" psql -c "CREATE USER $username WITH PASSWORD '$password';" >/dev/null 2>&1
    
    if [ "$privs" = "full" ]; then
        sudo -u "$PG_ADMIN" psql -c "GRANT ALL PRIVILEGES ON DATABASE $dbname TO $username;" >/dev/null 2>&1
    elif [ "$privs" = "read" ]; then
        sudo -u "$PG_ADMIN" psql -c "GRANT CONNECT ON DATABASE $dbname TO $username;" >/dev/null 2>&1
    fi
    log_operation "✓ PostgreSQL user '$username' created with $privs privileges on '$dbname'."
}

create_mysql_user() {
    read -rp "Enter new username: " username
    read -rsp "Enter new password: " password; echo
    read -rp "Enter database name: " dbname
    read -rp "Grant privileges? (full/read): " privs

    sudo mysql -u root -p"$MYSQL_ROOT_PASS" -e "CREATE USER '$username'@'%' IDENTIFIED BY '$password';" 2>/dev/null
    
    if [ "$privs" = "full" ]; then
        sudo mysql -u root -p"$MYSQL_ROOT_PASS" -e "GRANT ALL PRIVILEGES ON $dbname.* TO '$username'@'%';" 2>/dev/null
    elif [ "$privs" = "read" ]; then
        sudo mysql -u root -p"$MYSQL_ROOT_PASS" -e "GRANT SELECT ON $dbname.* TO '$username'@'%';" 2>/dev/null
    fi
    sudo mysql -u root -p"$MYSQL_ROOT_PASS" -e "FLUSH PRIVILEGES;" 2>/dev/null
    
    log_operation "✓ MySQL user '$username' created with $privs privileges on '$dbname'."
}

create_mongo_user() {
    read -rp "Enter new username: " username
    read -rsp "Enter new password: " password; echo
    read -rp "Enter database name: " dbname
    read -rp "Grant privileges? (full/read): " privs

    local role="read"
    if [ "$privs" = "full" ]; then
        role="readWrite"
    fi

    mongosh admin -u admin -p "$MONGO_ADMIN_PASS" --eval "db.getSiblingDB('$dbname').createUser({user: '$username', pwd: '$password', roles: [{role: '$role', db: '$dbname'}]})" >/dev/null 2>&1
    
    log_operation "✓ MongoDB user '$username' created with '$role' privileges on '$dbname'."
}

list_all_users() {
    echo "--- PostgreSQL Users ---"
    sudo -u "$PG_ADMIN" psql -c "\du"
    
    echo "--- MySQL Users ---"
    sudo mysql -u root -p"$MYSQL_ROOT_PASS" -e "SELECT User, Host FROM mysql.user;" 2>/dev/null
    
    echo "--- MongoDB Users (Admin DB) ---"
    mongosh admin -u admin -p "$MONGO_ADMIN_PASS" --eval "db.getUsers()" --quiet 2>/dev/null
}

log_operation "Started Database User Manager."

while true; do
    show_menu
    read -rp "Choice: " choice

    case $choice in
        1) create_pg_user ;;
        2) create_mysql_user ;;
        3) create_mongo_user ;;
        4) list_all_users ;;
        5) log_operation "Exited Database User Manager."; break ;;
        *) echo "Invalid option. Please try again." ;;
    esac
    echo ""
done