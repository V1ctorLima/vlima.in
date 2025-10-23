# Victor Lima

Personal website and blog built with Gatsby, featuring modern web technologies and automated deployment.

## Tech Stack

- **Frontend**: Gatsby, React, MDX
- **Styling**: CSS Modules
- **Deployment**: Docker, Nginx
- **CI/CD**: GitHub Actions

## Features

- Responsive design
- MDX support for interactive content
- RSS feed
- Google Analytics integration
- Automated deployment pipeline

## Development

```bash
# Install dependencies
npm install

# Start development server
npm run develop

# Build for production
npm run build
```

## Deployment

For production deployment on a VPS with automatic startup on reboot:

```bash
# Run the automated setup script
sudo ./setup-service.sh
```

For detailed deployment instructions, see [DEPLOYMENT.md](DEPLOYMENT.md).

### Quick Deployment Commands

```bash
# Check service status
sudo systemctl status vlimain.service

# Restart service
sudo systemctl restart vlimain.service

# View logs
sudo journalctl -u vlimain.service -f
```

## Files

- `setup-service.sh` - Automated systemd service setup
- `deploy.sh` - Deployment script for CI/CD
- `DEPLOYMENT.md` - Complete deployment guide
- `SERVICE_INFO.md` - Service management reference

## License

MIT License - see LICENSE file for details.
