#!/bin/bash

# This script restores the original MDX files from the backup directory

# Check if backup directory exists
if [ ! -d ".mdx-backup" ]; then
  echo "Error: Backup directory .mdx-backup not found!"
  exit 1
fi

# Remove the placeholder MDX files
echo "Removing placeholder MDX files..."
find content -name "*.mdx" -delete

# Restore the original MDX files
echo "Restoring original MDX files..."
find .mdx-backup -name "*.mdx" -exec bash -c 'mkdir -p "$(dirname "{}" | sed "s/\.mdx-backup\///")" && cp "{}" "$(echo "{}" | sed "s/\.mdx-backup\///")"' \;

# Remove the backup directory
echo "Cleaning up backup directory..."
rm -rf .mdx-backup

echo "Done! Original MDX files have been restored." 