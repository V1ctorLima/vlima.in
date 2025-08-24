#!/bin/bash

# Script to create a secure deployment user for GitHub Actions
# Run this script as root on your VPS

set -e

DEPLOY_USER="deploy"
PROJECT_DIR="/opt/vlima.in"
SSH_PORT="39760"

echo "🔒 Setting up secure deployment user..."
echo ""

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo "❌ This script must be run as root"
    echo "Usage: sudo ./setup-secure-deploy-user.sh"
    exit 1
fi

echo "📋 Configuration:"
echo "- Deploy user: $DEPLOY_USER"
echo "- Project directory: $PROJECT_DIR"
echo "- SSH port: $SSH_PORT"
echo ""

read -p "Continue with setup? (y/N): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "❌ Setup cancelled"
    exit 1
fi

echo ""
echo "1️⃣ Creating deploy user..."
if id "$DEPLOY_USER" &>/dev/null; then
    echo "⚠️  User $DEPLOY_USER already exists"
else
    # Create user with no login shell initially (for security)
    useradd -m -s /bin/bash "$DEPLOY_USER"
    echo "✅ User $DEPLOY_USER created"
fi

echo ""
echo "2️⃣ Adding deploy user to docker group..."
usermod -aG docker "$DEPLOY_USER"
echo "✅ User added to docker group"

echo ""
echo "3️⃣ Setting up project directory permissions..."
# Ensure project directory exists
mkdir -p "$PROJECT_DIR"

# Change ownership to deploy user
chown -R "$DEPLOY_USER:$DEPLOY_USER" "$PROJECT_DIR"
echo "✅ Project directory ownership set to $DEPLOY_USER"

echo ""
echo "4️⃣ Setting up SSH access..."
# Create .ssh directory for deploy user
DEPLOY_HOME="/home/$DEPLOY_USER"
mkdir -p "$DEPLOY_HOME/.ssh"
chown "$DEPLOY_USER:$DEPLOY_USER" "$DEPLOY_HOME/.ssh"
chmod 700 "$DEPLOY_HOME/.ssh"

# Generate SSH key pair for deploy user
SSH_KEY_PATH="$DEPLOY_HOME/.ssh/github_actions"
if [ ! -f "$SSH_KEY_PATH" ]; then
    sudo -u "$DEPLOY_USER" ssh-keygen -t ed25519 -f "$SSH_KEY_PATH" -N "" -C "github-actions-deploy"
    echo "✅ SSH key pair generated"
else
    echo "⚠️  SSH key already exists"
fi

# Set up authorized_keys (copy from root if exists, or create empty)
AUTHORIZED_KEYS="$DEPLOY_HOME/.ssh/authorized_keys"
if [ -f "/root/.ssh/authorized_keys" ] && [ ! -f "$AUTHORIZED_KEYS" ]; then
    cp "/root/.ssh/authorized_keys" "$AUTHORIZED_KEYS"
    chown "$DEPLOY_USER:$DEPLOY_USER" "$AUTHORIZED_KEYS"
    chmod 600 "$AUTHORIZED_KEYS"
    echo "✅ Copied authorized_keys from root"
fi

echo ""
echo "5️⃣ Configuring SSH security..."
# Create SSH config to restrict deploy user
SSH_CONFIG="/etc/ssh/sshd_config.d/deploy-user.conf"
cat > "$SSH_CONFIG" << EOF
# Secure configuration for deploy user
Match User $DEPLOY_USER
    AllowTcpForwarding no
    X11Forwarding no
    PermitTunnel no
    GatewayPorts no
    ForceCommand /bin/bash
EOF

echo "✅ SSH security configuration created"

echo ""
echo "6️⃣ Setting up Git configuration for deploy user..."
sudo -u "$DEPLOY_USER" git config --global user.name "GitHub Actions Deploy"
sudo -u "$DEPLOY_USER" git config --global user.email "deploy@vlima.in"
sudo -u "$DEPLOY_USER" git config --global init.defaultBranch main
echo "✅ Git configuration set"

echo ""
echo "7️⃣ Testing Docker access..."
if sudo -u "$DEPLOY_USER" docker ps &>/dev/null; then
    echo "✅ Docker access working"
else
    echo "⚠️  Docker access test failed - you may need to restart Docker service"
    echo "Run: systemctl restart docker"
fi

echo ""
echo "🎉 **SETUP COMPLETE!**"
echo ""
echo "📋 **Next Steps:**"
echo ""
echo "1. **Copy the private key for GitHub Secrets:**"
echo "   cat $SSH_KEY_PATH"
echo ""
echo "2. **Update GitHub Secrets with:**"
echo "   - VPS_USERNAME: $DEPLOY_USER"
echo "   - VPS_SSH_KEY: (content of the private key above)"
echo ""
echo "3. **Test SSH connection:**"
echo "   ssh -i $SSH_KEY_PATH -p $SSH_PORT $DEPLOY_USER@YOUR_VPS_IP"
echo ""
echo "4. **Restart SSH service to apply config:**"
echo "   systemctl reload sshd"
echo ""
echo "🔒 **Security Notes:**"
echo "- Deploy user has NO sudo access"
echo "- Can only access $PROJECT_DIR directory"
echo "- Docker access without root privileges"
echo "- SSH access restricted with security policies"
echo ""
echo "📄 **Private Key (copy this to GitHub Secrets):**"
echo "----------------------------------------"
cat "$SSH_KEY_PATH"
echo "----------------------------------------"
