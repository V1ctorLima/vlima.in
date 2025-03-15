#!/bin/bash

# Exit on error
set -e

# Configuration
SERVER_NAME=${SERVER_NAME:-"vlima.in"}
DOCKER_COMPOSE_FILE="docker-compose.yml"

# Check if running as part of an automatic update
if [ "$1" == "--auto-update" ]; then
  echo "Running as automatic update from Git webhook..."
  
  # Pull latest changes from git
  echo "Pulling latest changes from Git repository..."
  git pull origin main
fi

# Run the fix-mdx script to fix any MDX issues
echo "Fixing MDX files..."
./fix-mdx.sh

# Build the Docker image (which will build the Gatsby site inside the container)
echo "Building Docker image..."
docker-compose -f $DOCKER_COMPOSE_FILE build

# Stop and remove existing containers
echo "Stopping existing containers..."
docker-compose -f $DOCKER_COMPOSE_FILE down

# Start the new container with the SERVER_NAME environment variable
echo "Starting new container with server name: $SERVER_NAME"
SERVER_NAME=$SERVER_NAME docker-compose -f $DOCKER_COMPOSE_FILE up -d

# Print status
echo "Deployment completed successfully!"
echo "Your Gatsby blog is now running at https://$SERVER_NAME"
echo ""
echo "Configuration Summary:"
echo "---------------------"
echo "Server Name: $SERVER_NAME"
echo "Docker Compose File: $DOCKER_COMPOSE_FILE"
echo ""
echo "Note: The server is configured to only accept requests for $SERVER_NAME, not for the VPS IP address." 