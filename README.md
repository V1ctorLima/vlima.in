# Victor Lima's Gatsby Blog

A personal blog built with Gatsby, featuring MDX support, custom components, and a tagging system.

## Features

- Responsive design
- MDX support for interactive content
- Custom components like Panels
- Tag system for categorizing posts
- Dark/light mode support
- Optimized for performance

## Development

### Prerequisites

- Node.js (v14 or later)
- npm or yarn

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/yourusername/gatsby-blog.git
   cd gatsby-blog
   ```

2. Install dependencies:
   ```bash
   npm install
   ```

3. Start the development server:
   ```bash
   npm run develop
   ```

4. Open your browser and visit `http://localhost:8000`

## Deployment

This blog is designed to be deployed on a VPS using Docker. See [DEPLOYMENT.md](DEPLOYMENT.md) for detailed deployment instructions.

### Quick Deployment

To deploy the blog to your VPS:

1. Build the site:
   ```bash
   npm run build
   ```

2. Run the deployment script:
   ```bash
   ./deploy.sh
   ```

## GitHub Integration and Automatic Updates

This repository is set up to automatically deploy changes when you push to the main branch.

### Setting Up GitHub Webhook

1. On your VPS, start the webhook server:
   ```bash
   ./start-webhook.sh
   ```
   This will generate a secret key and start the webhook server on port 9000.

2. In your GitHub repository settings, go to "Webhooks" and add a new webhook:
   - Payload URL: `http://your-vps-ip:9000/webhook`
   - Content type: `application/json`
   - Secret: Use the secret generated in step 1 (found in `.webhook-secret`)
   - Events: Select "Just the push event"

3. Install the webhook as a systemd service on your VPS:
   ```bash
   sudo cp webhook.service /etc/systemd/system/
   sudo systemctl daemon-reload
   sudo systemctl enable webhook
   sudo systemctl start webhook
   ```

### Security Considerations

- The webhook server only accepts requests with a valid signature
- The server is configured to only respond to the domain name, not the IP address
- All sensitive information is excluded from the Git repository via `.gitignore`

## Configuration

### Server Name

By default, the server is configured to use `vlima.in` as the domain name. To change this:

```bash
SERVER_NAME=yourdomain.com ./deploy.sh
```

### SSL Certificates

The deployment automatically generates self-signed SSL certificates. For production, you should replace these with proper certificates from Let's Encrypt or another provider.

## License

This project is licensed under the MIT License - see the LICENSE file for details. # Test automatic deployment
# Testing VPS_USERNAME fix
# Testing direct VPS IP connection
