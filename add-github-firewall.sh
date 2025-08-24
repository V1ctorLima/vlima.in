#!/bin/bash

# Script to add GitHub Actions IP ranges to existing firewall
# This does NOT reset existing rules - it only adds new ones

set -e

echo "🎯 Adding GitHub Actions IP ranges to existing firewall..."
echo ""

# Get GitHub Actions IP ranges
echo "📡 Fetching current GitHub Actions IP ranges..."
curl -s https://api.github.com/meta | jq -r '.actions[]' > /tmp/github_actions_ips.txt

if [ ! -s /tmp/github_actions_ips.txt ]; then
    echo "❌ Failed to fetch GitHub Actions IP ranges"
    exit 1
fi

# Count IPv4 ranges only
ipv4_count=$(grep -v ':' /tmp/github_actions_ips.txt | wc -l)
echo "✅ Found $ipv4_count IPv4 ranges (skipping IPv6 for compatibility)"
echo ""

echo "🛡️  Current firewall status for port 39760:"
sudo ufw status | grep 39760 || echo "No existing rules for port 39760"
echo ""

echo "⚠️  This script will:"
echo "1. Keep all existing firewall rules"
echo "2. Add GitHub Actions IPv4 ranges for SSH port 39760"
echo "3. Skip IPv6 ranges for compatibility"
echo ""

read -p "Do you want to continue? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Aborted"
    exit 1
fi

echo ""
echo "📝 Adding GitHub Actions IPv4 ranges for SSH port 39760..."

# Counter for progress
current=0

# Process only IPv4 ranges
grep -v ':' /tmp/github_actions_ips.txt | while IFS= read -r ip_range; do
    current=$((current + 1))
    echo "[$current/$ipv4_count] Adding rule for $ip_range"
    
    # Add the rule
    if sudo ufw allow from "$ip_range" to any port 39760 proto tcp 2>/dev/null; then
        echo "  ✅ Added: $ip_range -> port 39760"
    else
        echo "  ⚠️  Rule may already exist: $ip_range"
    fi
done

echo ""
echo "✅ GitHub Actions IP ranges added!"
echo ""
echo "📊 Updated firewall status for port 39760:"
sudo ufw status | grep 39760 || echo "No rules found (this might be normal if rules are shown differently)"

echo ""
echo "🚀 GitHub Actions should now be able to connect to your VPS on port 39760!"

# Cleanup
rm -f /tmp/github_actions_ips.txt
