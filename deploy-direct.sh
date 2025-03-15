#!/bin/bash

# Exit on error
set -e

# Configuration
SERVER_NAME=${SERVER_NAME:-"vlima.in"}
IMAGE_NAME="vlima-gatsby"
CONTAINER_NAME="vlima-gatsby-container"

# Check if running as part of an automatic update
if [ "$1" == "--auto-update" ]; then
  echo "Running as automatic update from Git webhook..."
  
  # Pull latest changes from git
  echo "Pulling latest changes from Git repository..."
  git pull origin main
fi

# Create a temporary directory for the build
echo "Creating temporary build directory..."
mkdir -p .build-tmp

# Copy files if they exist
echo "Copying project files..."
[ -d "src" ] && cp -r src .build-tmp/ || echo "No src directory found, skipping..."
[ -d "nginx" ] && cp -r nginx .build-tmp/ || echo "No nginx directory found, skipping..."
[ -d "static" ] && cp -r static .build-tmp/ || echo "No static directory found, skipping..."
[ -d "public" ] && cp -r public .build-tmp/ || echo "No public directory found, skipping..."

# Copy configuration files
for file in package*.json gatsby-*.js; do
  if [ -f "$file" ]; then
    cp "$file" .build-tmp/
  fi
done

# Create content directory structure in the temporary directory
echo "Creating minimal content files..."
mkdir -p .build-tmp/content/blog/hello-world
cat > .build-tmp/content/blog/hello-world/index.mdx << 'EOF'
---
title: Hello World
date: "2023-05-01T22:12:03.284Z"
description: "Hello World"
slug: hello-world
---

# Hello World

This is a placeholder post.
EOF

# Create Dockerfile in the temporary directory
echo "Creating Dockerfile..."
cat > .build-tmp/Dockerfile << 'EOF'
FROM node:18-alpine

# Install nginx and other dependencies
RUN apk add --no-cache nginx bash openssl

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy all files
COPY . .

# Build the Gatsby site
RUN npm run build

# Set up nginx
RUN mkdir -p /run/nginx
RUN mkdir -p /etc/nginx/ssl /etc/nginx/conf.d
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
EOF

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