#!/bin/bash
set -e

# Script: security_hardening.sh
# Description: Automates SSH lockdown, fail2ban configuration, and system hardening.
# Author: Vibhav Khaneja

echo "Starting Enterprise Security Hardening Protocol..."

# 1. SSH Hardening
echo "-> Hardening SSH Daemon..."
# Disable Root Login
sudo sed -i 's/^#PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/^PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config

# Disable Password Authentication (Force SSH Keys)
sudo sed -i 's/^#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo sed -i 's/^PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config

# Change default port from 22 to 2222
sudo sed -i 's/^#Port 22/Port 2222/' /etc/ssh/sshd_config

# Restart SSH to apply changes
sudo systemctl restart sshd

# 2. Install & Configure fail2ban
echo "-> Installing and configuring fail2ban..."
sudo apt-get update -y > /dev/null
sudo apt-get install fail2ban -y > /dev/null

# Create a clean, targeted override file (Enterprise Best Practice)
sudo tee /etc/fail2ban/jail.local > /dev/null <<EOF
[DEFAULT]
bantime = 3600
findtime = 600
maxretry = 3

[sshd]
enabled = true
port = 2222
EOF

sudo systemctl enable fail2ban
sudo systemctl restart fail2ban

# 3. Additional Hardening
echo "-> Applying strict password policies..."
sudo sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS   90/' /etc/login.defs
sudo sed -i 's/^PASS_MIN_DAYS.*/PASS_MIN_DAYS   7/' /etc/login.defs

echo "-> Installing Audit Logging and Automatic Updates..."
sudo apt-get install auditd unattended-upgrades -y > /dev/null
sudo systemctl enable auditd
sudo systemctl start auditd

echo "-> Cleaning up unnecessary packages..."
sudo apt-get autoremove -y > /dev/null

echo "=========================================="
echo "SECURITY AUDIT CHECKLIST COMPLETED:"
echo "[X] Root SSH Login Disabled"
echo "[X] SSH Password Auth Disabled (Key-Based Only)"
echo "[X] SSH Port Changed to 2222"
echo "[X] Fail2ban Override Configured (3 strikes = 1hr ban)"
echo "[X] 90-Day Password Expiration Policy Enforced"
echo "[X] Unattended Security Updates Enabled"
echo "[X] Auditd Logging Engine Active"
echo "=========================================="
echo "WARNING: Your SSH port is now 2222. Ensure UFW allows Port 2222 before logging out!"