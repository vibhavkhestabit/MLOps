#!/bin/bash
set -euo pipefail

# Script: user_provision.sh
# Description: Automates user creation, group assignment, and SSH directory setup.
# Author: Vibhav Khaneja
# Date: 2026-04-15
# Usage: sudo ./user_provision.sh users.txt

readonly EXIT_SUCCESS=0
readonly EXIT_ERROR=1

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_DIR="${SCRIPT_DIR}/logs"
LOG_FILE="${LOG_DIR}/user_provision.log"

mkdir -p "$LOG_DIR"

log_info() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] $1" | tee -a "$LOG_FILE"; }
log_error() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] $1" | tee -a "$LOG_FILE" >&2; }

# Security Check: Ensure the script is run as root (sudo)
if [[ "${EUID}" -ne 0 ]]; then
    log_error "This script must be run as root. Please use sudo."
    exit $EXIT_ERROR
fi

# Check if the input file was provided
if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <users.csv>"
    exit $EXIT_ERROR
fi

INPUT_FILE="$1"

if [[ ! -f "$INPUT_FILE" ]]; then
    log_error "File $INPUT_FILE not found!"
    exit $EXIT_ERROR
fi

log_info "Starting user provisioning from $INPUT_FILE..."

# Skip the first line (header), then read line by line using comma as the separator (IFS)
tail -n +2 "$INPUT_FILE" | while IFS=',' read -r username fullname group role; do
    
    # Skip empty lines
    [[ -z "$username" ]] && continue
    
    log_info "Processing user: $username ($fullname) for group: $group"

    # 1. Check if group exists, if not, create it
    if ! getent group "$group" > /dev/null; then
        log_info "Creating missing group: $group"
        groupadd "$group"
    fi

    # 2. Check if user exists, if not, create them
    if id "$username" > /dev/null 2>&1; then
        log_info "User $username already exists. Skipping creation."
    else
        # Create user with a home directory (-m), specify the full name (-c), and assign secondary group (-G)
        useradd -m -c "$fullname" -G "$group" -s /bin/bash "$username"
        log_info "Created user: $username"
        
        # 3. Generate a secure random password (12 characters)
        set +o pipefail
        temp_pass=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 12)
        set -o pipefail
        
        # Set the password silently
        echo "$username:$temp_pass" | chpasswd
        
        # 4. Force password change on first login
        chage -d 0 "$username"
        log_info "Set temporary password and forced reset for: $username"
        
        # Print credentials to the screen (so you can give them to the user)
        echo "======================================"
        echo " Credentials for $fullname"
        echo " Username: $username"
        echo " Password: $temp_pass"
        echo "======================================"

        # 5. Create secure SSH directory
        SSH_DIR="/home/$username/.ssh"
        mkdir -p "$SSH_DIR"
        
        # The crucial permissions step:
        chown -R "$username:$username" "$SSH_DIR" # Give ownership to the user
        chmod 700 "$SSH_DIR"                      # 700 means ONLY the owner can read/write/execute
        
        log_info "Secured SSH directory for $username with 700 permissions."
    fi
done

log_info "User provisioning completed successfully."
exit $EXIT_SUCCESS