# Deployment Guide

This document provides detailed instructions for deploying your Gatsby blog to a VPS using Docker and setting up Cloudflare as a CDN.

## Prerequisites

- A VPS with at least 1GB RAM running Ubuntu 20.04 or later
- Docker and Docker Compose installed on your VPS
- A domain name (e.g., vlima.in)
- A Cloudflare account for DNS management and CDN
- Git installed on your VPS

## Deployment Steps

### 1. Preparing Your VPS

1. Install Docker:
   ```bash
   curl -fsSL https://get.docker.com -o get-docker.sh
   sudo sh get-docker.sh
   ```

2. Install Docker Compose:
   ```bash
   sudo curl -L "https://github.com/docker/compose/releases/download/v2.18.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
   sudo chmod +x /usr/local/bin/docker-compose
   ```

3. Install Git and Node.js:
   ```bash
   sudo apt update
   sudo apt install -y git nodejs npm
   ```

### 2. Setting Up Your Repository

1. Clone your repository on the VPS:
   ```bash
   git clone https://github.com/yourusername/gatsby-blog.git
   cd gatsby-blog
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

### 3. Deploying Your Gatsby Blog

1. Build the Gatsby site:
   ```bash
   npm run build
   ```

2. Run the deployment script:
   ```bash
   ./deploy.sh
   ```

### 4. Setting Up Automatic Deployment with GitHub Webhooks

1. Start the webhook server and generate a secret:
   ```bash
   ./start-webhook.sh
   ```
   Note the secret that is generated and displayed.

2. Set up the webhook as a systemd service:
   ```bash
   sudo cp webhook.service /etc/systemd/system/
   sudo systemctl daemon-reload
   sudo systemctl enable webhook
   sudo systemctl start webhook
   ```

3. Configure your GitHub repository:
   - Go to your repository on GitHub
   - Navigate to Settings > Webhooks
   - Click "Add webhook"
   - Set Payload URL to `http://your-vps-ip:9000/webhook`
   - Set Content type to `application/json`
   - Set Secret to the value generated in step 1
   - Select "Just the push event"
   - Click "Add webhook"

4. Test the webhook:
   - Make a small change to your repository
   - Commit and push to the main branch
   - Check the webhook server logs on your VPS:
     ```bash
     sudo journalctl -u webhook -f
     ```

### 5. Configuring Cloudflare

1. Add your domain to Cloudflare:
   - Create a Cloudflare account if you don't have one
   - Add your domain and follow the setup instructions
   - Update your domain's nameservers to those provided by Cloudflare

2. Configure DNS settings:
   - Add an A record pointing to your VPS IP address
   - Set the proxy status to "Proxied" (orange cloud)

3. SSL/TLS settings:
   - Go to the SSL/TLS section
   - Set the encryption mode to "Full (strict)"
   - Enable "Always Use HTTPS"

4. Configure caching:
   - Go to the Caching section
   - Set the Browser Cache TTL to a reasonable value (e.g., 4 hours)
   - Enable "Always Online"

5. Add page rules:
   - Create a page rule for `*yourdomain.com/*`
   - Set "Cache Level" to "Cache Everything"
   - Set "Edge Cache TTL" to a reasonable value (e.g., 2 hours)

### 6. Firewall Configuration

1. Configure your VPS firewall to allow only necessary traffic:
   ```bash
   sudo ufw allow ssh
   sudo ufw allow http
   sudo ufw allow https
   sudo ufw allow 9000/tcp  # For the webhook server
   sudo ufw enable
   ```

## Maintenance and Updates

### Updating Your Blog

With the webhook setup, your blog will automatically update whenever you push changes to the main branch of your GitHub repository.

For manual updates:
```bash
cd /path/to/your/gatsby-blog
git pull
./deploy.sh
```

### Viewing Logs

To view Docker container logs:
```bash
docker-compose logs -f
```

To view webhook server logs:
```bash
sudo journalctl -u webhook -f
```

## Troubleshooting

### Container Issues

1. Check if the container is running:
   ```bash
   docker-compose ps
   ```

2. View container logs:
   ```bash
   docker-compose logs -f
   ```

### Webhook Issues

1. Check webhook server status:
   ```bash
   sudo systemctl status webhook
   ```

2. View webhook logs:
   ```bash
   sudo journalctl -u webhook -f
   ```

3. Verify the webhook is properly configured in GitHub:
   - Go to your repository settings
   - Check the webhook's "Recent Deliveries" tab
   - Look for successful delivery responses (HTTP 200)

### DNS and Cloudflare Issues

1. Verify DNS settings in Cloudflare
2. Check SSL/TLS configuration
3. Test your domain with SSL checker tools

## Security Considerations

1. **Firewall**: Ensure your firewall is properly configured to allow only necessary traffic.

2. **SSL/TLS**: Use proper SSL certificates for production. The deployment script generates self-signed certificates by default, but you should replace them with Let's Encrypt certificates for production.

3. **Webhook Security**: The webhook server validates requests using a secret key. Keep this key secure and don't commit it to your repository.

4. **Docker Secrets**: For sensitive information, use Docker secrets or environment variables that are not committed to your repository.

5. **Regular Updates**: Keep your system, Docker, and Node.js updated with security patches.

6. **Backups**: Regularly backup your blog content and database if applicable. 