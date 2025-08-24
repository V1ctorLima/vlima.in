# GitHub Actions Automatic Deployment Setup

This guide will help you set up automatic deployment to your VPS using GitHub Actions whenever you push to the main branch.

## 🚀 Quick Setup Overview

1. **Generate SSH Key Pair** for secure VPS access
2. **Configure GitHub Secrets** with your VPS credentials
3. **Test the Deployment** by pushing to main branch

## 📋 Detailed Setup Steps

### Step 1: Generate SSH Key Pair

On your **local machine**, generate a new SSH key pair specifically for GitHub Actions:

```bash
# Generate a new SSH key pair (don't use a passphrase for automation)
ssh-keygen -t ed25519 -C "github-actions@vlima.in" -f ~/.ssh/github_actions_key

# This creates two files:
# ~/.ssh/github_actions_key (private key - for GitHub Secrets)
# ~/.ssh/github_actions_key.pub (public key - for VPS)
```

### Step 2: Configure Your VPS

**On your VPS**, add the public key to authorized_keys:

```bash
# Copy the public key content
cat ~/.ssh/github_actions_key.pub

# On your VPS, add it to authorized_keys
mkdir -p ~/.ssh
echo "YOUR_PUBLIC_KEY_CONTENT_HERE" >> ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys
chmod 700 ~/.ssh
```

**Test the SSH connection** from your local machine:

```bash
ssh -i ~/.ssh/github_actions_key your_username@your_vps_ip
```

### Step 3: Configure GitHub Repository Secrets

Go to your GitHub repository → **Settings** → **Secrets and variables** → **Actions** → **New repository secret**

Add these secrets:

| Secret Name | Description | Example Value |
|-------------|-------------|---------------|
| `VPS_HOST` | Your VPS IP address or domain | `123.456.789.012` |
| `VPS_USERNAME` | Your VPS username | `ubuntu` or `root` |
| `VPS_SSH_KEY` | Private key content | Content of `~/.ssh/github_actions_key` |
| `VPS_PORT` | SSH port (optional, defaults to 22) | `22` |
| `VPS_PROJECT_PATH` | Path to your project on VPS | `/home/ubuntu/vlima.in` |
| `GATSBY_GA_MEASUREMENT_ID` | Google Analytics ID | `G-H7MZ8PJ08S` |
| `SERVER_NAME` | Your domain name | `vlima.in` |

### Step 4: Prepare Your VPS Project Directory

**On your VPS**, clone your repository if you haven't already:

```bash
# Clone your repository
git clone https://github.com/YOUR_USERNAME/vlima.in.git
cd vlima.in

# Make sure deploy script is executable
chmod +x deploy.sh

# Install Docker and Docker Compose if not already installed
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Log out and back in for Docker group changes to take effect
```

## 🔧 How It Works

1. **Trigger**: When you push to the `main` branch
2. **Build**: GitHub Actions builds your Gatsby site with environment variables
3. **Deploy**: Connects to your VPS via SSH and runs the deployment script
4. **Update**: Pulls latest code, rebuilds Docker containers, and starts the site

## 🧪 Testing the Setup

1. **Make a small change** to your website (e.g., edit a blog post)
2. **Commit and push** to the main branch:
   ```bash
   git add .
   git commit -m "Test automatic deployment"
   git push origin main
   ```
3. **Check GitHub Actions** tab in your repository to see the deployment progress
4. **Verify your website** is updated at https://vlima.in

## 📊 Monitoring Deployments

- **GitHub Actions Tab**: See deployment logs and status
- **VPS Logs**: Check Docker container logs with `docker-compose logs -f`
- **Website Status**: Monitor your site at https://vlima.in

## 🔒 Security Best Practices

✅ **What we implemented:**
- Dedicated SSH key for GitHub Actions (not your personal key)
- GitHub Secrets for sensitive data (never in code)
- SSH key without passphrase for automation
- Limited scope deployment script

✅ **Additional recommendations:**
- Use a dedicated deployment user on your VPS (not root)
- Configure firewall to allow only necessary ports
- Regularly rotate SSH keys
- Monitor deployment logs for suspicious activity

## 🛠️ Troubleshooting

### Common Issues:

**SSH Connection Failed:**
- Check VPS_HOST, VPS_USERNAME, and VPS_SSH_KEY secrets
- Verify SSH key is correctly formatted (include `-----BEGIN` and `-----END` lines)
- Test SSH connection manually from your local machine

**Docker Permission Denied:**
- Make sure your VPS user is in the docker group: `sudo usermod -aG docker $USER`
- Log out and back in after adding to docker group

**Build Fails:**
- Check if all required secrets are set in GitHub
- Verify GATSBY_GA_MEASUREMENT_ID format (should be G-XXXXXXXXXX)

**Deployment Script Fails:**
- Check VPS_PROJECT_PATH points to correct directory
- Ensure deploy.sh has execute permissions: `chmod +x deploy.sh`

## 🔄 Updating the Workflow

The workflow file is located at `.github/workflows/deploy.yml`. You can modify it to:
- Add additional build steps
- Deploy to multiple environments
- Add notification integrations (Slack, Discord, etc.)
- Run tests before deployment

## 🎉 Next Steps

Once this is working, you can:
1. **Add staging environment** for testing changes
2. **Set up monitoring** with tools like Uptime Robot
3. **Add backup automation** for your content
4. **Configure CDN caching** optimization
5. **Add SSL certificate automation** with Let's Encrypt
