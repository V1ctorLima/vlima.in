#!/bin/bash

# This script removes the problematic MDX file and replaces it with a simple one
# Run this before building the Docker image

echo "Removing problematic MDX files..."
rm -f content/blog/hello-world/index.mdx

echo "Creating a simple MDX file..."
cat > content/blog/hello-world/index.mdx << 'EOF'
---
title: Hello World
date: "2023-05-01T22:12:03.284Z"
description: "Hello World - My first blog post"
slug: hello-world
tags: [introduction, gatsby, web-development]
---

# Hello World

This is my first post on my new blog! How exciting!

I'm sure I'll write a lot more interesting things in the future.

## What I've learned

Gatsby is a powerful framework for building static websites.

## Next Steps

I plan to write more about web development soon.
EOF

echo "Done! Now you can run ./deploy.sh" 