#!/bin/bash
set -euo pipefail

# Script: permission_audit.sh
# Description: Scans system for permission vulnerabilities and generates a report.
# Author: Vibhav Khaneja
# Date: 2026-04-15
# Usage: sudo ./permission_audit.sh

# Configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPORT_DIR="${SCRIPT_DIR}/reports"
REPORT_FILE="${REPORT_DIR}/permission_audit.txt"

# Create the reports folder if it doesn't exist
mkdir -p "$REPORT_DIR"

# Define the directories we want to audit
SCAN_DIRS="/home /var/www /tmp"

# Initialize Report Header
echo "==========================================" > "$REPORT_FILE"
echo "        PERMISSION AUDIT REPORT           " >> "$REPORT_FILE"
echo " Date: $(date '+%Y-%m-%d %H:%M:%S')" >> "$REPORT_FILE"
echo "==========================================" >> "$REPORT_FILE"
echo "" >> "$REPORT_FILE"

echo "Starting security audit across: $SCAN_DIRS..."

# 1. Scan for 777 Files (World-Readable/Writable/Executable)
echo "[+] Scanning for dangerous 777 files..."
echo "--- 777 FILES FOUND ---" >> "$REPORT_FILE"
find $SCAN_DIRS -type f -perm 777 2>/dev/null | while read -r file; do
    echo "DANGER: $file" >> "$REPORT_FILE"
    echo "  -> FIX: Run 'chmod 644 $file' or 'chmod 755 $file'" >> "$REPORT_FILE"
done

# 2. Scan for World-Writable Directories
echo "[+] Scanning for World-Writable Directories..."
echo -e "\n--- WORLD-WRITABLE DIRECTORIES ---" >> "$REPORT_FILE"
find $SCAN_DIRS -type d -perm -0002 2>/dev/null | while read -r dir; do
    echo "WARNING: $dir" >> "$REPORT_FILE"
    echo "  -> FIX: Run 'chmod o-w $dir' or add sticky bit 'chmod +t $dir'" >> "$REPORT_FILE"
done

# 3. Scan for SUID/SGID Binaries (Privilege Escalation Risks)
echo "[+] Scanning for SUID/SGID Binaries..."
echo -e "\n--- SUID/SGID BINARIES ---" >> "$REPORT_FILE"
find $SCAN_DIRS -type f \( -perm -4000 -o -perm -2000 \) 2>/dev/null | while read -r file; do
    echo "NOTICE: $file" >> "$REPORT_FILE"
    echo "  -> FIX: Verify if intended. If not, run 'chmod u-s,g-s $file'" >> "$REPORT_FILE"
done

# 4. Scan for Orphaned Files (Files owned by deleted users)
echo "[+] Scanning for Orphaned Files..."
echo -e "\n--- ORPHANED FILES ---" >> "$REPORT_FILE"
find $SCAN_DIRS -nouser 2>/dev/null | while read -r file; do
    echo "ORPHAN: $file" >> "$REPORT_FILE"
    echo "  -> FIX: Reassign ownership with 'chown root:root $file' or delete it." >> "$REPORT_FILE"
done

echo -e "\n==========================================" >> "$REPORT_FILE"
echo "Audit Complete." >> "$REPORT_FILE"
echo "==========================================" >> "$REPORT_FILE"

echo "Audit finished successfully! Report saved to: $REPORT_FILE"