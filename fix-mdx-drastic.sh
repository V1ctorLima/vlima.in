#!/bin/bash

# This script takes a more drastic approach by temporarily moving all MDX files
# out of the way and replacing them with minimal placeholder files

# Create a backup directory
echo "Creating backup directory..."
mkdir -p .mdx-backup

# Move all MDX files to the backup directory
echo "Moving all MDX files to backup..."
find content -name "*.mdx" -exec bash -c 'mkdir -p ".mdx-backup/$(dirname "{}")" && mv "{}" ".mdx-backup/{}"' \;

# Create minimal placeholder MDX files
echo "Creating minimal placeholder MDX files..."

# Hello World
mkdir -p content/blog/hello-world
cat > content/blog/hello-world/index.mdx << 'EOF'
---
title: Hello World
date: "2023-05-01T22:12:03.284Z"
description: "Hello World"
slug: hello-world
---

# Hello World

This is a placeholder post.
EOF

# My Second Post
mkdir -p content/blog/my-second-post
cat > content/blog/my-second-post/index.mdx << 'EOF'
---
title: My Second Post
date: "2023-05-06T23:46:37.121Z"
description: "My Second Post"
slug: my-second-post
---

# My Second Post

This is a placeholder post.
EOF

# New Beginnings
mkdir -p content/blog/new-beginnings
cat > content/blog/new-beginnings/index.mdx << 'EOF'
---
title: New Beginnings
date: "2023-05-28T22:40:32.169Z"
description: "New Beginnings"
slug: new-beginnings
---

# New Beginnings

This is a placeholder post.
EOF

# Test Post
mkdir -p content/blog/test-post
cat > content/blog/test-post/index.mdx << 'EOF'
---
title: Test Post
date: "2023-06-01T12:00:00.000Z"
description: "Test Post"
slug: test-post
---

# Test Post

This is a placeholder post.
EOF

echo "Done! Now you can run the Docker build."
echo "After the build completes, run ./restore-mdx.sh to restore your original MDX files." 