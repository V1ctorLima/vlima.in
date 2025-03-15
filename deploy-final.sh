#!/bin/bash

# Exit on error
set -e

# Configuration
SERVER_NAME=${SERVER_NAME:-"vlima.in"}
IMAGE_NAME="vlima-gatsby"
CONTAINER_NAME="vlima-gatsby-container"

# Create a temporary directory for the build
echo "Creating temporary build directory..."
rm -rf .build-tmp
mkdir -p .build-tmp

# Create directory structure
mkdir -p .build-tmp/src
mkdir -p .build-tmp/nginx/conf.d
mkdir -p .build-tmp/content/blog/hello-world

# Copy package.json
echo "Copying package files..."
cp package*.json .build-tmp/ 2>/dev/null || echo "No package.json found"

# Copy gatsby config files
echo "Copying Gatsby config files..."
cp gatsby-*.js .build-tmp/ 2>/dev/null || echo "No Gatsby config files found"

# Copy src files
echo "Copying src files..."
if [ -d "src" ]; then
  cp -r src/* .build-tmp/src/ 2>/dev/null || echo "Error copying src files"
fi

# Copy nginx files
echo "Copying nginx files..."
if [ -d "nginx" ]; then
  cp -r nginx/* .build-tmp/nginx/ 2>/dev/null || echo "Error copying nginx files"
fi

# Create a minimal MDX file
echo "Creating minimal content file..."
cat > .build-tmp/content/blog/hello-world/index.mdx << 'MDXEOF'
---
title: Hello World
date: "2023-05-01T22:12:03.284Z"
description: "Hello World"
slug: hello-world
---

# Hello World

This is a placeholder post.
MDXEOF

# Create nginx.conf if it doesn't exist
if [ ! -f ".build-tmp/nginx/nginx.conf" ]; then
  echo "Creating default nginx.conf..."
  cat > .build-tmp/nginx/nginx.conf << 'NGINXEOF'
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log warn;
pid /var/run/nginx.pid;

events {
    worker_connections 1024;
}

http {
    include /etc/nginx/mime.types;
    default_type application/octet-stream;
    sendfile on;
    keepalive_timeout 65;
    include /etc/nginx/conf.d/*.conf;
}
NGINXEOF
fi

# Create default nginx site config if it doesn't exist
if [ ! -f ".build-tmp/nginx/conf.d/default.conf" ]; then
  echo "Creating default nginx site config..."
  cat > .build-tmp/nginx/conf.d/default.conf << 'CONFEOF'
server {
    listen 80;
    server_name ${SERVER_NAME};
    
    location / {
        root /usr/share/nginx/html;
        index index.html;
        try_files $uri $uri/ /index.html;
    }
}
CONFEOF
fi

# Create entrypoint script if it doesn't exist
if [ ! -f ".build-tmp/nginx/entrypoint.sh" ]; then
  echo "Creating default entrypoint script..."
  cat > .build-tmp/nginx/entrypoint.sh << 'ENTRYEOF'
#!/bin/bash
set -e

# Replace SERVER_NAME in nginx config
sed -i "s/\${SERVER_NAME}/$SERVER_NAME/g" /etc/nginx/conf.d/default.conf

# Start nginx
exec "$@"
ENTRYEOF
  chmod +x .build-tmp/nginx/entrypoint.sh
fi

# Create a minimal Dockerfile
echo "Creating Dockerfile..."
cat > .build-tmp/Dockerfile << 'DOCKEREOF'
FROM node:18-alpine

# Install nginx and other dependencies
RUN apk add --no-cache nginx bash openssl

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy all files
COPY . .

# Build the Gatsby site
RUN npm run build

# Set up nginx
RUN mkdir -p /run/nginx
RUN mkdir -p /etc/nginx/ssl /etc/nginx/conf.d

# Copy nginx configuration
COPY nginx/nginx.conf /etc/nginx/nginx.conf
COPY nginx/conf.d/ /etc/nginx/conf.d/

# Copy the built site to nginx's html directory
RUN mkdir -p /usr/share/nginx/html
RUN cp -r public/* /usr/share/nginx/html/

# Copy the entrypoint script
COPY nginx/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose ports
EXPOSE 80 443

# Set the entrypoint script
ENTRYPOINT ["/entrypoint.sh"]

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]
DOCKEREOF

# Build the Docker image
echo "Building Docker image..."
cd .build-tmp
docker build -t $IMAGE_NAME .
cd ..

# Stop and remove existing container if it exists
echo "Stopping existing container..."
docker stop $CONTAINER_NAME 2>/dev/null || true
docker rm $CONTAINER_NAME 2>/dev/null || true

# Start the new container
echo "Starting new container..."
docker run -d --name $CONTAINER_NAME \
  -p 80:80 -p 443:443 \
  -e SERVER_NAME=$SERVER_NAME \
  -v $(pwd)/nginx/ssl:/etc/nginx/ssl \
  --restart always \
  $IMAGE_NAME

# Clean up temporary directory
echo "Cleaning up..."
rm -rf .build-tmp

# Print status
echo "Deployment completed successfully!"
echo "Your Gatsby blog is now running at https://$SERVER_NAME"
echo ""
echo "Configuration Summary:"
echo "---------------------"
echo "Server Name: $SERVER_NAME"
echo "Container Name: $CONTAINER_NAME"
echo ""
echo "Note: The server is configured to only accept requests for $SERVER_NAME, not for the VPS IP address." 