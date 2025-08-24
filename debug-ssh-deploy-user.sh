#!/bin/bash

# Debug script for SSH authentication issues with deploy user
# Run this as root on your VPS

DEPLOY_USER="deploy"
DEPLOY_HOME="/home/$DEPLOY_USER"
SSH_KEY_PATH="$DEPLOY_HOME/.ssh/github_actions"
AUTHORIZED_KEYS="$DEPLOY_HOME/.ssh/authorized_keys"

echo "🔍 **SSH DEPLOY USER DEBUG**"
echo ""

# Check if deploy user exists
echo "1️⃣ Checking deploy user..."
if id "$DEPLOY_USER" &>/dev/null; then
    echo "✅ Deploy user exists"
    echo "   Home directory: $DEPLOY_HOME"
else
    echo "❌ Deploy user does not exist!"
    exit 1
fi

# Check SSH directory and permissions
echo ""
echo "2️⃣ Checking SSH directory..."
if [ -d "$DEPLOY_HOME/.ssh" ]; then
    echo "✅ SSH directory exists"
    echo "   Permissions: $(ls -ld $DEPLOY_HOME/.ssh | awk '{print $1}')"
    echo "   Owner: $(ls -ld $DEPLOY_HOME/.ssh | awk '{print $3":"$4}')"
    
    # Check if permissions are correct (should be 700)
    PERMS=$(stat -c "%a" "$DEPLOY_HOME/.ssh")
    if [ "$PERMS" = "700" ]; then
        echo "✅ SSH directory permissions are correct (700)"
    else
        echo "❌ SSH directory permissions are wrong ($PERMS), should be 700"
        echo "   Fixing permissions..."
        chmod 700 "$DEPLOY_HOME/.ssh"
        chown "$DEPLOY_USER:$DEPLOY_USER" "$DEPLOY_HOME/.ssh"
    fi
else
    echo "❌ SSH directory does not exist!"
    echo "   Creating SSH directory..."
    mkdir -p "$DEPLOY_HOME/.ssh"
    chmod 700 "$DEPLOY_HOME/.ssh"
    chown "$DEPLOY_USER:$DEPLOY_USER" "$DEPLOY_HOME/.ssh"
fi

# Check private key
echo ""
echo "3️⃣ Checking private key..."
if [ -f "$SSH_KEY_PATH" ]; then
    echo "✅ Private key exists"
    echo "   Permissions: $(ls -l $SSH_KEY_PATH | awk '{print $1}')"
    echo "   Owner: $(ls -l $SSH_KEY_PATH | awk '{print $3":"$4}')"
    
    # Check permissions (should be 600)
    PERMS=$(stat -c "%a" "$SSH_KEY_PATH")
    if [ "$PERMS" = "600" ]; then
        echo "✅ Private key permissions are correct (600)"
    else
        echo "❌ Private key permissions are wrong ($PERMS), should be 600"
        chmod 600 "$SSH_KEY_PATH"
        chown "$DEPLOY_USER:$DEPLOY_USER" "$SSH_KEY_PATH"
    fi
else
    echo "❌ Private key does not exist!"
    echo "   Generating new SSH key pair..."
    sudo -u "$DEPLOY_USER" ssh-keygen -t ed25519 -f "$SSH_KEY_PATH" -N "" -C "github-actions-deploy"
fi

# Check public key
echo ""
echo "4️⃣ Checking public key..."
PUBLIC_KEY_PATH="${SSH_KEY_PATH}.pub"
if [ -f "$PUBLIC_KEY_PATH" ]; then
    echo "✅ Public key exists"
    echo "   Content: $(cat $PUBLIC_KEY_PATH)"
else
    echo "❌ Public key does not exist!"
    if [ -f "$SSH_KEY_PATH" ]; then
        echo "   Generating public key from private key..."
        sudo -u "$DEPLOY_USER" ssh-keygen -y -f "$SSH_KEY_PATH" > "$PUBLIC_KEY_PATH"
        chown "$DEPLOY_USER:$DEPLOY_USER" "$PUBLIC_KEY_PATH"
    fi
fi

# Check authorized_keys
echo ""
echo "5️⃣ Checking authorized_keys..."
if [ -f "$AUTHORIZED_KEYS" ]; then
    echo "✅ authorized_keys exists"
    echo "   Permissions: $(ls -l $AUTHORIZED_KEYS | awk '{print $1}')"
    echo "   Owner: $(ls -l $AUTHORIZED_KEYS | awk '{print $3":"$4}')"
    echo "   Number of keys: $(wc -l < $AUTHORIZED_KEYS)"
    
    # Check permissions (should be 600)
    PERMS=$(stat -c "%a" "$AUTHORIZED_KEYS")
    if [ "$PERMS" = "600" ]; then
        echo "✅ authorized_keys permissions are correct (600)"
    else
        echo "❌ authorized_keys permissions are wrong ($PERMS), should be 600"
        chmod 600 "$AUTHORIZED_KEYS"
        chown "$DEPLOY_USER:$DEPLOY_USER" "$AUTHORIZED_KEYS"
    fi
    
    # Check if public key is in authorized_keys
    if [ -f "$PUBLIC_KEY_PATH" ]; then
        PUBLIC_KEY_CONTENT=$(cat "$PUBLIC_KEY_PATH")
        if grep -q "$PUBLIC_KEY_CONTENT" "$AUTHORIZED_KEYS"; then
            echo "✅ Public key is in authorized_keys"
        else
            echo "❌ Public key is NOT in authorized_keys"
            echo "   Adding public key to authorized_keys..."
            cat "$PUBLIC_KEY_PATH" >> "$AUTHORIZED_KEYS"
            chmod 600 "$AUTHORIZED_KEYS"
            chown "$DEPLOY_USER:$DEPLOY_USER" "$AUTHORIZED_KEYS"
        fi
    fi
else
    echo "❌ authorized_keys does not exist!"
    echo "   Creating authorized_keys with public key..."
    if [ -f "$PUBLIC_KEY_PATH" ]; then
        cat "$PUBLIC_KEY_PATH" > "$AUTHORIZED_KEYS"
        chmod 600 "$AUTHORIZED_KEYS"
        chown "$DEPLOY_USER:$DEPLOY_USER" "$AUTHORIZED_KEYS"
    fi
fi

# Check SSH daemon configuration
echo ""
echo "6️⃣ Checking SSH daemon configuration..."
if grep -q "PubkeyAuthentication yes" /etc/ssh/sshd_config; then
    echo "✅ PubkeyAuthentication is enabled"
else
    echo "⚠️  PubkeyAuthentication might not be enabled"
fi

# Test SSH connection locally
echo ""
echo "7️⃣ Testing SSH connection locally..."
if sudo -u "$DEPLOY_USER" ssh -i "$SSH_KEY_PATH" -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$DEPLOY_USER@localhost" "echo 'SSH test successful'" 2>/dev/null; then
    echo "✅ Local SSH connection works"
else
    echo "❌ Local SSH connection failed"
fi

# Show the private key for GitHub Secrets
echo ""
echo "8️⃣ **PRIVATE KEY FOR GITHUB SECRETS:**"
echo "Copy this EXACT content to VPS_SSH_KEY:"
echo ""
echo "----------------------------------------"
cat "$SSH_KEY_PATH"
echo "----------------------------------------"
echo ""
echo "📋 **GitHub Secrets to update:**"
echo "- VPS_USERNAME: deploy"
echo "- VPS_SSH_KEY: (the private key above)"
echo ""
echo "🔧 **If issues persist, try:**"
echo "1. Restart SSH service: systemctl restart sshd"
echo "2. Check SSH logs: tail -f /var/log/auth.log"
echo "3. Test from another machine: ssh -i key deploy@YOUR_VPS_IP -p 39760"
