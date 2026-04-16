#!/bin/bash
set -euo pipefail

# Script: zone_generator.sh
# Description: Automates DNS zone creation from a CSV file.
# Author: Vibhav Khaneja

CSV_FILE="hosts.csv"
FORWARD_ZONE="/etc/bind/zones/db.devops.lab"
REVERSE_ZONE="/etc/bind/zones/db.192.168.1"
BACKUP_DIR="/backup/dns"
DOMAIN="devops.lab"

# Generate a dynamic serial number based on today's date (YYYYMMDD01)
SERIAL=$(date +%Y%m%d01)

echo "Starting DNS Automation Engine..."

# 1. The Backup Protocol
echo "-> Backing up existing infrastructure..."
sudo mkdir -p "$BACKUP_DIR"
sudo cp "$FORWARD_ZONE" "${BACKUP_DIR}/db.devops.lab.bak_$(date +%s)" 2>/dev/null || true
sudo cp "$REVERSE_ZONE" "${BACKUP_DIR}/db.192.168.1.bak_$(date +%s)" 2>/dev/null || true

# 2. Create Temporary Workspaces (mktemp creates hidden, secure temp files)
TMP_FWD=$(mktemp)
TMP_REV=$(mktemp)

# 3. Write the Forward Zone Header (SOA)
cat <<EOF > "$TMP_FWD"
\$TTL    604800
@       IN      SOA     ns1.${DOMAIN}. admin.${DOMAIN}. (
                        ${SERIAL}  ; Serial
                        604800     ; Refresh
                        86400      ; Retry
                        2419200    ; Expire
                        604800 )   ; Negative Cache TTL
; Name servers
@       IN      NS      ns1.${DOMAIN}.
ns1     IN      A       192.168.1.10
; --- Automated Records Below ---
EOF

# 4. Write the Reverse Zone Header (SOA)
cat <<EOF > "$TMP_REV"
\$TTL    604800
@       IN      SOA     ns1.${DOMAIN}. admin.${DOMAIN}. (
                        ${SERIAL}
                        604800
                        86400
                        2419200
                        604800 )
@       IN      NS      ns1.${DOMAIN}.
10      IN      PTR     ns1.${DOMAIN}.
; --- Automated Records Below ---
EOF

# 5. Parse the CSV and inject the records
echo "-> Parsing $CSV_FILE..."

# tail -n +2 skips the header row (hostname,ip,type,alias)
tail -n +2 "$CSV_FILE" | while IFS=, read -r hostname ip type alias; do
    
    # Strip any hidden carriage returns (Windows formatting bugs)
    alias=$(echo "$alias" | tr -d '\r')

    # A) Write the Forward A Record
    echo "${hostname} IN A ${ip}" >> "$TMP_FWD"
    
    # B) Write the Forward CNAME Record (ONLY if the alias column isn't empty)
    if [ -n "$alias" ]; then 
        echo "${alias} IN CNAME ${hostname}" >> "$TMP_FWD"
    fi

    # C) Write the Reverse PTR Record
    # Extract the 4th block of the IP using the 'cut' tool (192.168.1.21 -> 21)
    LAST_OCTET=$(echo "$ip" | cut -d'.' -f4)
    echo "${LAST_OCTET} IN PTR ${hostname}.${DOMAIN}." >> "$TMP_REV"

done

# 6. The Safety Check
echo "-> Validating generated machine code..."
if named-checkzone "$DOMAIN" "$TMP_FWD" >/dev/null && named-checkzone "1.168.192.in-addr.arpa" "$TMP_REV" >/dev/null; then
    echo "-> Validation [PASS]. Overwriting production servers..."
    
    # Move the temporary files into the official BIND directory
    sudo mv "$TMP_FWD" "$FORWARD_ZONE"
    sudo mv "$TMP_REV" "$REVERSE_ZONE"
    
    # PERMISSION FIX: Unlock the files so the BIND user can read them
    sudo chmod 644 "$FORWARD_ZONE"
    sudo chmod 644 "$REVERSE_ZONE"
    
    # Restart the DNS engine to load the new data
    sudo systemctl restart bind9
    echo "==========================================="
    echo "[SUCCESS] New DNS infrastructure is LIVE!"
else
    echo "-> Validation [FAILED]. Fatal syntax error detected."
    echo "-> ABORTING deployment. Production servers were NOT modified."
    rm "$TMP_FWD" "$TMP_REV"
    exit 1
fi