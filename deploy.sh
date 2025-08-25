#!/bin/bash

# Exit on error
set -e

# Configuration
SERVER_NAME=${SERVER_NAME:-"vlima.in"}
DOCKER_COMPOSE_FILE="docker-compose.yml"
LOG_FILE="/tmp/deploy.log"

# Function to log messages with timestamp
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

log "Starting deployment process..."
log "Server Name: $SERVER_NAME"
log "Docker Compose File: $DOCKER_COMPOSE_FILE"

# Check if running as part of an automatic update
if [ "$1" == "--auto-update" ]; then
  log "Running as automatic update from Git webhook..."
  
  # Pull latest changes from git
  log "Pulling latest changes from Git repository..."
  git pull origin main
fi

# Check if .env file exists and source it
if [ -f ".env" ]; then
    log "Loading environment variables from .env file..."
    export $(cat .env | grep -v '^#' | xargs)
else
    log "No .env file found, using system environment variables..."
fi

# Build the Docker image (which will build the Gatsby site inside the container)
log "Building Docker image with no cache to ensure fresh build..."
if ! docker-compose -f $DOCKER_COMPOSE_FILE build --no-cache; then
    log "❌ ERROR: Docker build failed!"
    exit 1
fi

# Stop and remove existing containers
log "Stopping existing containers..."
if ! docker-compose -f $DOCKER_COMPOSE_FILE down; then
    log "❌ ERROR: Failed to stop containers!"
    exit 1
fi

# Force remove any containers with the same name
log "Force removing any existing containers..."
docker rm -f vlimain_gatsby_1 2>/dev/null || true

# Remove any dangling images to ensure clean state
log "Cleaning up old Docker images..."
docker image prune -f || true

# Start the new container with the SERVER_NAME environment variable
log "Starting new container with server name: $SERVER_NAME"
if ! SERVER_NAME=$SERVER_NAME docker-compose -f $DOCKER_COMPOSE_FILE up -d; then
    log "❌ ERROR: Failed to start new containers!"
    exit 1
fi

# Wait a moment for containers to start
sleep 5

# Show detailed container information
log "Container status after deployment:"
docker ps -a | head -10

# Check if containers are running
if docker-compose -f $DOCKER_COMPOSE_FILE ps | grep -q "Up"; then
    log "✅ Deployment completed successfully!"
    log "Your Gatsby blog is now running at https://$SERVER_NAME"
    
    # Show container creation time to verify it's new
    CONTAINER_ID=$(docker ps -q --filter "name=vlimain_gatsby")
    if [ ! -z "$CONTAINER_ID" ]; then
        CONTAINER_CREATED=$(docker inspect --format='{{.Created}}' $CONTAINER_ID)
        log "New container created at: $CONTAINER_CREATED"
    fi
    
    # Test if the site is responding
    if curl -s -o /dev/null -w "%{http_code}" "http://localhost" | grep -q "200\|301\|302"; then
        log "✅ Website is responding correctly"
    else
        log "⚠️  Website may not be responding correctly"
    fi
else
    log "❌ Error: Containers failed to start"
    log "Container status:"
    docker-compose -f $DOCKER_COMPOSE_FILE ps
    docker ps -a
    exit 1
fi

log ""
log "Configuration Summary:"
log "---------------------"
log "Server Name: $SERVER_NAME"
log "Docker Compose File: $DOCKER_COMPOSE_FILE"
log "Log File: $LOG_FILE"
log ""
log "Note: The server is configured to only accept requests for $SERVER_NAME, not for the VPS IP address." 