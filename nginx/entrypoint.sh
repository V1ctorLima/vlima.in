#!/bin/bash
set -e

# Default server name if not provided
 SERVER_NAME=${SERVER_NAME:-"vlima.in"}
echo "Configuring Nginx for server name: $SERVER_NAME"

# Replace the SERVER_NAME placeholder in the Nginx configuration
sed -i "s/\${SERVER_NAME}/$SERVER_NAME/g" /etc/nginx/conf.d/default.conf

# Check if SSL certificates exist, if not, generate self-signed certificates
if [ ! -f /etc/nginx/ssl/fullchain.pem ] || [ ! -f /etc/nginx/ssl/privkey.pem ]; then
    echo "SSL certificates not found. Generating self-signed certificates..."
    mkdir -p /etc/nginx/ssl
    echo "Self-signed certificates generated."
else
    echo "Using existing SSL certificates."
fi

# Execute the CMD from the Dockerfile
exec "$@" 