#!/bin/bash

# Helper script to get the deploy user's SSH private key
# Run this as root on your VPS

DEPLOY_USER="deploy"
SSH_KEY_PATH="/home/$DEPLOY_USER/.ssh/github_actions"

echo "🔑 **DEPLOY USER SSH KEY**"
echo ""
echo "Copy this private key to GitHub Secrets > VPS_SSH_KEY:"
echo ""
echo "----------------------------------------"
if [ -f "$SSH_KEY_PATH" ]; then
    cat "$SSH_KEY_PATH"
else
    echo "❌ SSH key not found at $SSH_KEY_PATH"
    echo "Make sure you ran setup-secure-deploy-user.sh first"
fi
echo "----------------------------------------"
echo ""
echo "📋 **GitHub Secrets to update:**"
echo "1. VPS_USERNAME: deploy"
echo "2. VPS_SSH_KEY: (the private key above)"
echo ""
echo "🌐 **Update at:**"
echo "https://github.com/V1ctorLima/vlima.in/settings/secrets/actions"
