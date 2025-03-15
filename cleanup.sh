#!/bin/bash

# This script removes all deployment scripts except deploy-final.sh
echo "Cleaning up old deployment scripts..."

# List of scripts to remove
SCRIPTS_TO_REMOVE=(
  "deploy.sh"
  "deploy-simple.sh"
  "deploy-minimal.sh"
  "deploy-direct.sh"
  "fix-mdx.sh"
  "fix-mdx-drastic.sh"
  "restore-mdx.sh"
)

# Remove each script if it exists
for script in "${SCRIPTS_TO_REMOVE[@]}"; do
  if [ -f "$script" ]; then
    echo "Removing $script..."
    rm "$script"
  fi
done

echo "Done! Only deploy-final.sh remains."
echo "Use ./deploy-final.sh to deploy your site." 