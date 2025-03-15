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

# Copy only essential files
echo "Copying essential files..."
mkdir -p .build-tmp/src
mkdir -p .build-tmp/nginx
mkdir -p .build-tmp/content/blog/hello-world

# Copy package.json and gatsby config files
if [ -f "package.json" ]; then
  cp package.json .build-tmp/
fi
if [ -f "package-lock.json" ]; then
  cp package-lock.json .build-tmp/
fi
for file in gatsby-*.js; do
  if [ -f "$file" ]; then
    cp "$file" .build-tmp/
  fi
done

# Copy src directory if it exists
if [ -d "src" ]; then
  cp -r src/* .build-tmp/src/
fi

# Copy nginx directory if it exists
if [ -d "nginx" ]; then
  cp -r nginx/* .build-tmp/nginx/
fi

# Create a minimal MDX file
echo "Creating minimal content file..."
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

# Create a minimal Dockerfile
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