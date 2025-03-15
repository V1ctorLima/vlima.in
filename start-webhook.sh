#!/bin/bash

# Exit on error
set -e

# Generate a webhook secret if it doesn't exist
if [ ! -f .webhook-secret ]; then
  echo "Generating webhook secret..."
  node -e "console.log(require('crypto').randomBytes(20).toString('hex'))" > .webhook-secret
  echo "Secret generated and saved to .webhook-secret"
  echo "Use this secret when setting up your GitHub webhook"
fi

# Start the webhook server
echo "Starting webhook server..."
node webhook.js 