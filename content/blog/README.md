# Blog Content Guide

This directory contains all the blog posts for your Gatsby website. Each blog post is stored in a date-based directory structure with an `index.md` file.

## Blog Post Structure

We use a date-based folder structure to organize posts chronologically:

```
content/
└── blog/
    └── YYYY/
        └── MM/
            └── DD-post-slug/
                ├── index.md
                ├── featured-image.jpg (optional)
                └── other-images.jpg (optional)
```

For example:
```
content/
└── blog/
    └── 2023/
        ├── 05/
        │   ├── 01-hello-world/
        │   │   └── index.md
        │   └── 15-getting-started-with-gatsby/
        │       └── index.md
        └── 06/
            └── 01-using-markdown-in-gatsby/
                ├── index.md
                └── markdown-example.jpg
```

## Creating a New Blog Post

To create a new blog post:

1. Create a new directory structure based on the current date:
   - Year folder (YYYY)
   - Month folder (MM)
   - Day and slug folder (DD-post-slug)

2. Create an `index.md` file inside this directory.

3. Add the required frontmatter at the top of the file:

```markdown
---
title: Your Post Title
date: "YYYY-MM-DD"
description: "A brief description of your post"
slug: post-slug
featuredImage: ./featured-image.jpg (optional)
---

Your content goes here...
```

4. Write your post content in Markdown format below the frontmatter.

## Including Images

To include images in your blog post:

1. Place the image files in the same directory as your `index.md` file.
2. For a featured image (displayed at the top of the post), add it to the frontmatter:
   ```markdown
   featuredImage: ./image.jpg
   ```
3. For images within the post content, reference them in your Markdown using relative paths:
   ```markdown
   ![Image Alt Text](./image.jpg)
   ```

## Frontmatter Fields

- **title**: The title of your blog post
- **date**: The publication date in "YYYY-MM-DD" format
- **description**: A brief description of your post (used for SEO and previews)
- **slug**: The URL slug for your post (should match the last part of the directory name)
- **featuredImage**: (Optional) Path to an image to be displayed at the top of the post

## Example

```markdown
---
title: Hello World
date: "2023-05-01"
description: "My first blog post"
slug: hello-world
featuredImage: ./featured.jpg
---

# Hello World!

This is my first blog post...
```

This will create a blog post accessible at `/blog/hello-world`.

## Markdown Tips

- Use `#` for headings (more `#` symbols for smaller headings)
- Use `*` or `_` for italic text: *italic* or _italic_
- Use `**` or `__` for bold text: **bold** or __bold__
- Use `-` or `*` for unordered lists
- Use numbers for ordered lists
- Use ``` for code blocks
- Use `[text](url)` for links
- Use `![alt](image-path)` for images 