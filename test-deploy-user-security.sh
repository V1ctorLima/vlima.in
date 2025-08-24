#!/bin/bash

# Script to test the security of the deploy user setup
# Run this script as the deploy user to verify restrictions

DEPLOY_USER="deploy"
PROJECT_DIR="/opt/vlima.in"

echo "🔍 **TESTING DEPLOY USER SECURITY**"
echo ""
echo "Current user: $(whoami)"
echo "Current directory: $(pwd)"
echo ""

# Test 1: Check if user has sudo access
echo "1️⃣ Testing sudo access (should FAIL)..."
if sudo -n true 2>/dev/null; then
    echo "❌ SECURITY ISSUE: Deploy user has sudo access!"
else
    echo "✅ Good: Deploy user has no sudo access"
fi

# Test 2: Test Docker access
echo ""
echo "2️⃣ Testing Docker access (should WORK)..."
if docker ps &>/dev/null; then
    echo "✅ Good: Docker access working without sudo"
else
    echo "❌ Issue: Docker access not working"
fi

# Test 3: Test project directory access
echo ""
echo "3️⃣ Testing project directory access..."
if [ -w "$PROJECT_DIR" ]; then
    echo "✅ Good: Can write to project directory"
else
    echo "❌ Issue: Cannot write to project directory"
fi

# Test 4: Test restricted directory access
echo ""
echo "4️⃣ Testing restricted directory access (should FAIL)..."
if [ -r "/root" ]; then
    echo "❌ SECURITY ISSUE: Can read /root directory!"
else
    echo "✅ Good: Cannot access /root directory"
fi

# Test 5: Test system directory write access
echo ""
echo "5️⃣ Testing system directory write access (should FAIL)..."
if touch /etc/test-file 2>/dev/null; then
    echo "❌ SECURITY ISSUE: Can write to /etc directory!"
    rm -f /etc/test-file
else
    echo "✅ Good: Cannot write to system directories"
fi

# Test 6: Test Git operations in project directory
echo ""
echo "6️⃣ Testing Git operations..."
if [ -d "$PROJECT_DIR/.git" ]; then
    cd "$PROJECT_DIR"
    if git status &>/dev/null; then
        echo "✅ Good: Git operations working in project directory"
    else
        echo "❌ Issue: Git operations not working"
    fi
else
    echo "⚠️  Project directory not initialized with Git"
fi

# Test 7: Test Docker Compose operations
echo ""
echo "7️⃣ Testing Docker Compose operations..."
if [ -f "$PROJECT_DIR/docker-compose.yml" ]; then
    cd "$PROJECT_DIR"
    if docker-compose config &>/dev/null; then
        echo "✅ Good: Docker Compose operations working"
    else
        echo "❌ Issue: Docker Compose operations not working"
    fi
else
    echo "⚠️  docker-compose.yml not found in project directory"
fi

echo ""
echo "🔒 **SECURITY TEST SUMMARY**"
echo ""
echo "✅ = Good security practice"
echo "❌ = Security issue that needs attention"
echo "⚠️  = Warning or informational"
echo ""
echo "If you see any ❌ issues, please review the setup!"
