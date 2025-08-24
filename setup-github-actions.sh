#!/bin/bash

# GitHub Actions Setup Helper Script
# This script helps you set up SSH keys and test the connection for GitHub Actions deployment

set -e

echo "🚀 GitHub Actions Deployment Setup Helper"
echo "=========================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_step() {
    echo -e "${BLUE}📋 $1${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Step 1: Generate SSH Key
print_step "Step 1: Generating SSH Key for GitHub Actions"
echo ""

SSH_KEY_PATH="$HOME/.ssh/github_actions_vlima_in"

if [ -f "$SSH_KEY_PATH" ]; then
    print_warning "SSH key already exists at $SSH_KEY_PATH"
    read -p "Do you want to overwrite it? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Using existing key..."
    else
        rm -f "$SSH_KEY_PATH" "$SSH_KEY_PATH.pub"
    fi
fi

if [ ! -f "$SSH_KEY_PATH" ]; then
    ssh-keygen -t ed25519 -C "github-actions@vlima.in" -f "$SSH_KEY_PATH" -N ""
    print_success "SSH key generated successfully!"
else
    print_success "Using existing SSH key"
fi

echo ""
print_step "Step 2: Public Key for VPS"
echo ""
echo "Copy this public key to your VPS ~/.ssh/authorized_keys file:"
echo ""
echo "----------------------------------------"
cat "$SSH_KEY_PATH.pub"
echo "----------------------------------------"
echo ""

# Step 3: Private Key for GitHub
print_step "Step 3: Private Key for GitHub Secrets"
echo ""
echo "Copy this private key to GitHub Secrets as 'VPS_SSH_KEY':"
echo ""
echo "----------------------------------------"
cat "$SSH_KEY_PATH"
echo "----------------------------------------"
echo ""

# Step 4: Test connection
print_step "Step 4: Test SSH Connection"
echo ""
read -p "Enter your VPS IP address or hostname: " VPS_HOST
read -p "Enter your VPS username (e.g., ubuntu, root): " VPS_USERNAME

echo ""
echo "Testing SSH connection..."

if ssh -i "$SSH_KEY_PATH" -o ConnectTimeout=10 -o StrictHostKeyChecking=no "$VPS_USERNAME@$VPS_HOST" "echo 'SSH connection successful!'" 2>/dev/null; then
    print_success "SSH connection test passed!"
else
    print_error "SSH connection failed!"
    echo ""
    echo "Troubleshooting steps:"
    echo "1. Make sure you've added the public key to your VPS ~/.ssh/authorized_keys"
    echo "2. Check if SSH service is running on your VPS"
    echo "3. Verify the VPS IP address and username"
    echo "4. Check firewall settings on your VPS"
    echo ""
    echo "Manual test command:"
    echo "ssh -i $SSH_KEY_PATH $VPS_USERNAME@$VPS_HOST"
fi

echo ""
print_step "Step 5: GitHub Secrets Configuration"
echo ""
echo "Add these secrets to your GitHub repository:"
echo "Repository → Settings → Secrets and variables → Actions → New repository secret"
echo ""
echo "VPS_HOST: $VPS_HOST"
echo "VPS_USERNAME: $VPS_USERNAME"
echo "VPS_SSH_KEY: [Copy the private key from above]"
echo "VPS_PORT: 22 (or your custom SSH port)"
echo "VPS_PROJECT_PATH: /home/$VPS_USERNAME/vlima.in (adjust as needed)"
echo "GATSBY_GA_MEASUREMENT_ID: G-H7MZ8PJ08S"
echo "SERVER_NAME: vlima.in"
echo ""

print_step "Step 6: VPS Preparation Commands"
echo ""
echo "Run these commands on your VPS to prepare for deployment:"
echo ""
echo "# Add the public key to authorized_keys"
echo "mkdir -p ~/.ssh"
echo "echo '$(cat "$SSH_KEY_PATH.pub")' >> ~/.ssh/authorized_keys"
echo "chmod 600 ~/.ssh/authorized_keys"
echo "chmod 700 ~/.ssh"
echo ""
echo "# Clone your repository (if not already done)"
echo "git clone https://github.com/YOUR_USERNAME/vlima.in.git"
echo "cd vlima.in"
echo ""
echo "# Make deploy script executable"
echo "chmod +x deploy.sh"
echo ""

print_success "Setup complete!"
echo ""
echo "Next steps:"
echo "1. Add the public key to your VPS authorized_keys"
echo "2. Configure GitHub Secrets with the values shown above"
echo "3. Push a commit to the main branch to trigger deployment"
echo ""
echo "For detailed instructions, see: GITHUB_ACTIONS_SETUP.md"
