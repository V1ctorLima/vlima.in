#!/bin/bash

# Script to configure firewall rules for GitHub Actions IP ranges
# This allows GitHub Actions to connect to your VPS on SSH port 39760

set -e

echo "🔥 Setting up firewall rules for GitHub Actions..."
echo ""

# Get GitHub Actions IP ranges
echo "📡 Fetching current GitHub Actions IP ranges..."
curl -s https://api.github.com/meta | jq -r '.actions[]' > /tmp/github_actions_ips.txt

if [ ! -s /tmp/github_actions_ips.txt ]; then
    echo "❌ Failed to fetch GitHub Actions IP ranges"
    exit 1
fi

echo "✅ Found $(wc -l < /tmp/github_actions_ips.txt) IP ranges"
echo ""

# Check if ufw is installed
if ! command -v ufw &> /dev/null; then
    echo "❌ ufw (Uncomplicated Firewall) is not installed"
    echo "Please install it first: sudo apt update && sudo apt install ufw"
    exit 1
fi

echo "🛡️  Current firewall status:"
sudo ufw status verbose
echo ""

echo "⚠️  This script will:"
echo "1. Reset the firewall (remove all existing rules)"
echo "2. Allow basic services (SSH on 22, HTTP on 80, HTTPS on 443)"
echo "3. Allow SSH on port 39760 from GitHub Actions IP ranges only"
echo "4. Enable the firewall"
echo ""

read -p "Do you want to continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Aborted"
    exit 1
fi

echo ""
echo "🔄 Resetting firewall..."
sudo ufw --force reset

echo "✅ Allowing basic services..."
sudo ufw allow ssh/tcp                    # SSH on port 22
sudo ufw allow http/tcp                   # HTTP on port 80  
sudo ufw allow https/tcp                  # HTTPS on port 443

echo "📝 Adding GitHub Actions IP ranges for SSH port 39760..."

# Counter for progress
total=$(wc -l < /tmp/github_actions_ips.txt)
current=0

while IFS= read -r ip_range; do
    current=$((current + 1))
    echo "[$current/$total] Adding rule for $ip_range"
    
    # Check if it's IPv6 (contains :) or IPv4
    if [[ $ip_range == *":"* ]]; then
        # IPv6 - skip for now as many VPS don't have IPv6 enabled
        echo "  ⏭️  Skipping IPv6 range: $ip_range"
    else
        # IPv4
        sudo ufw allow from "$ip_range" to any port 39760 proto tcp
        echo "  ✅ Added IPv4 rule: $ip_range -> port 39760"
    fi
done < /tmp/github_actions_ips.txt

echo ""
echo "🔥 Enabling firewall..."
sudo ufw --force enable

echo ""
echo "✅ Firewall configuration complete!"
echo ""
echo "📊 Final firewall status:"
sudo ufw status verbose

echo ""
echo "🎯 Summary:"
echo "- SSH (port 22): Open to all"
echo "- HTTP (port 80): Open to all" 
echo "- HTTPS (port 443): Open to all"
echo "- SSH (port 39760): Open only to GitHub Actions IP ranges"
echo ""
echo "🚀 GitHub Actions should now be able to connect to your VPS!"

# Cleanup
rm -f /tmp/github_actions_ips.txt
