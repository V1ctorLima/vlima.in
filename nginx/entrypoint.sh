#!/bin/bash
set -e

# Default server name if not provided
# SERVER_NAME=${SERVER_NAME:-"vlima.in"}
SERVER_NAME=${SERVER_NAME:-"localhost"}
echo "Configuring Nginx for server name: $SERVER_NAME"

# Replace the SERVER_NAME placeholder in the Nginx configuration
sed -i "s/\${SERVER_NAME}/$SERVER_NAME/g" /etc/nginx/conf.d/default.conf

# Check if SSL certificates exist, if not, generate self-signed certificates
if [ ! -f /etc/nginx/ssl/fullchain.pem ] || [ ! -f /etc/nginx/ssl/privkey.pem ]; then
    echo "SSL certificates not found. Generating self-signed certificates..."
    mkdir -p /etc/nginx/ssl
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/privkey.pem \
        -out /etc/nginx/ssl/fullchain.pem \
        -subj "/CN=$SERVER_NAME" \
        -addext "subjectAltName=DNS:$SERVER_NAME"
    echo "Self-signed certificates generated."
else
    echo "Using existing SSL certificates."
fi

# Execute the CMD from the Dockerfile
exec "$@" 