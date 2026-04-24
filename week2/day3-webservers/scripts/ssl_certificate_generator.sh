#!/bin/bash
set -e

# Script: ssl_certificate_generator.sh
# Description: Interactive tool to manage SSL/TLS certificates.
# Author: Vibhav Khaneja
# Date: 2026-04-24

show_menu() {
    echo "========================================"
    echo "       SSL Certificate Generator        "
    echo "========================================"
    echo "1) Generate self-signed certificate"
    echo "2) Generate Let's Encrypt certificate"
    echo "3) Renew certificate"
    echo "4) List certificates"
    echo "5) Exit"
    echo "========================================"
}

generate_self_signed() {
    read -rp "Enter domain name (e.g., devops.local): " domain
    read -rp "Enter organization: " org
    read -rp "Enter country code (e.g., US, IN): " country

    # Ensure directories exist
    sudo mkdir -p /etc/ssl/private /etc/ssl/certs
    
    # Generate the 2048-bit RSA key and certificate in one command using OpenSSL
    sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout "/etc/ssl/private/${domain}.key" \
        -out "/etc/ssl/certs/${domain}.crt" \
        -subj "/C=${country}/O=${org}/CN=${domain}" 2>/dev/null

    echo "✓ Private key generated"
    echo "✓ Certificate generated (valid 365 days)"
    echo "✓ Files saved:"
    echo "  - /etc/ssl/private/${domain}.key"
    echo "  - /etc/ssl/certs/${domain}.crt"
}

generate_lets_encrypt() {
    echo "Installing Certbot..."
    sudo apt-get update -qq && sudo apt-get install -y certbot >/dev/null 2>&1
    
    read -rp "Enter domain name (must be publicly resolvable): " domain
    read -rp "Enter email for renewal notices: " email

    echo "Attempting to generate Let's Encrypt certificate for $domain..."
    
    # Certbot standalone mode (Note: Port 80 must be free, or use webroot if Nginx is running)
    if sudo certbot certonly --standalone -d "$domain" -m "$email" --agree-tos --non-interactive; then
        echo "✓ Let's Encrypt certificate generated successfully."
        
        # Setup auto-renewal cron job directly in root crontab
        (sudo crontab -l 2>/dev/null; echo "0 3 * * 1 /usr/bin/certbot renew --quiet") | sudo crontab -
        echo "✓ Auto-renewal cron job configured (Runs weekly at 3 AM Monday)."
    else
        echo " Let's Encrypt validation failed."
        echo "   (Ensure your domain points to this server's public IP and port 80 is open)."
    fi
}

renew_cert() {
    if command -v certbot >/dev/null 2>&1; then
        echo "Attempting to renew Let's Encrypt certificates..."
        sudo certbot renew
        echo "✓ Renewal process finished."
    else
        echo "Certbot is not installed. No Let's Encrypt certificates to renew."
    fi
}

list_certs() {
    echo "--- Custom Self-Signed Certificates (/etc/ssl/certs/) ---"
    # Find files we created (ignoring the hundreds of default Ubuntu CA certs)
    find /etc/ssl/certs/ -name "*.crt" -not -name "ca-certificates.crt" | grep -v "ssl-cert" || echo "No custom certs found."
    
    echo ""
    echo "--- Let's Encrypt Certificates ---"
    if command -v certbot >/dev/null 2>&1; then
        sudo certbot certificates
    else
        echo "Certbot not installed. No Let's Encrypt certs."
    fi
}

while true; do
    show_menu
    read -rp "Choice: " choice

    case $choice in
        1) generate_self_signed ;;
        2) generate_lets_encrypt ;;
        3) renew_cert ;;
        4) list_certs ;;
        5) echo "Exiting..."; break ;;
        *) echo "Invalid option. Please try again." ;;
    esac
    echo ""
done