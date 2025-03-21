#!/bin/bash

# Create directories
mkdir -p public/featured-posts

# Create featured-posts-link.js
cat > public/featured-posts-link.js << 'EOL'
document.addEventListener('DOMContentLoaded', function() {
    // Create the featured posts link
    const featuredLink = document.createElement('a');
    featuredLink.href = '/featured-posts';
    featuredLink.textContent = '✨ Featured Posts';
    featuredLink.className = 'featured-link';
    
    // Style the link
    featuredLink.style.display = 'block';
    featuredLink.style.marginTop = '20px';
    featuredLink.style.padding = '10px 15px';
    featuredLink.style.backgroundColor = '#4fc3dc';
    featuredLink.style.color = '#fff';
    featuredLink.style.textDecoration = 'none';
    featuredLink.style.borderRadius = '5px';
    featuredLink.style.fontWeight = 'bold';
    featuredLink.style.textAlign = 'center';
    featuredLink.style.boxShadow = '0 2px 4px rgba(0,0,0,0.1)';
    featuredLink.style.transition = 'all 0.3s ease';
    
    // Add hover effect
    featuredLink.onmouseover = function() {
        this.style.backgroundColor = '#166088';
        this.style.transform = 'translateY(-2px)';
    };
    featuredLink.onmouseout = function() {
        this.style.backgroundColor = '#4fc3dc';
        this.style.transform = 'translateY(0)';
    };
    
    // Find a good place to insert the link (adjust selector as needed)
    const mainNavigation = document.querySelector('nav') || 
                          document.querySelector('header') || 
                          document.querySelector('.main-content');
    
    if (mainNavigation) {
        mainNavigation.appendChild(featuredLink);
    } else {
        // Fallback: add at the top of the body
        const bodyElement = document.body;
        bodyElement.insertBefore(featuredLink, bodyElement.firstChild);
    }
});
EOL

# Create featured posts index.html
cat > public/featured-posts/index.html << 'EOL'
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Featured Posts - Victor Lima</title>
    <link rel="icon" href="/favicon.ico">
    <style>
        :root {
            --primary-color: #4a6fa5;
            --secondary-color: #166088;
            --accent-color: #4fc3dc;
            --text-color: #333;
            --light-gray: #f5f5f5;
            --white: #ffffff;
            --card-shadow: 0 4px 8px rgba(0,0,0,0.1);
            --transition: all 0.3s ease;
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }

        body {
            background-color: var(--light-gray);
            color: var(--text-color);
            line-height: 1.6;
        }

        header {
            background-color: var(--primary-color);
            color: var(--white);
            padding: 1.5rem 0;
            text-align: center;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 2rem;
        }

        h1 {
            margin-bottom: 1rem;
            color: var(--white);
        }

        h2 {
            color: var(--secondary-color);
            margin-bottom: 2rem;
            text-align: center;
        }

        .featured-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 2rem;
            margin-top: 2rem;
        }

        .post-card {
            background-color: var(--white);
            border-radius: 8px;
            overflow: hidden;
            box-shadow: var(--card-shadow);
            transition: var(--transition);
        }

        .post-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 16px rgba(0,0,0,0.15);
        }

        .post-image {
            width: 100%;
            height: 180px;
            object-fit: cover;
        }

        .post-content {
            padding: 1.5rem;
        }

        .post-title {
            font-size: 1.2rem;
            color: var(--secondary-color);
            margin-bottom: 0.5rem;
        }

        .post-date {
            font-size: 0.85rem;
            color: #666;
            margin-bottom: 1rem;
            display: block;
        }

        .post-excerpt {
            color: #555;
            font-size: 0.95rem;
            margin-bottom: 1rem;
        }

        .read-more {
            display: inline-block;
            color: var(--accent-color);
            text-decoration: none;
            font-weight: 600;
            transition: var(--transition);
        }

        .read-more:hover {
            color: var(--secondary-color);
        }

        .back-link {
            display: block;
            margin-top: 2rem;
            text-align: center;
            color: var(--secondary-color);
            text-decoration: none;
            font-weight: 600;
        }

        .back-link:hover {
            text-decoration: underline;
        }

        @media (max-width: 768px) {
            .featured-grid {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <header>
        <h1>Victor Lima</h1>
        <p>Featured Articles & Blog Posts</p>
    </header>

    <div class="container">
        <h2>Highlighted Content</h2>
        
        <div class="featured-grid">
            <!-- Featured Post 1 -->
            <div class="post-card">
                <img src="https://source.unsplash.com/random/600x400/?technology" alt="Blog post thumbnail" class="post-image">
                <div class="post-content">
                    <h3 class="post-title">Getting Started with Cloud Computing</h3>
                    <span class="post-date">April 5, 2023</span>
                    <p class="post-excerpt">Learn the fundamentals of cloud computing and how to leverage platforms like AWS, Azure, and Google Cloud for your projects.</p>
                    <a href="#" class="read-more">Read More →</a>
                </div>
            </div>
            
            <!-- Featured Post 2 -->
            <div class="post-card">
                <img src="https://source.unsplash.com/random/600x400/?coding" alt="Blog post thumbnail" class="post-image">
                <div class="post-content">
                    <h3 class="post-title">Modern JavaScript: The Good Parts</h3>
                    <span class="post-date">June 12, 2023</span>
                    <p class="post-excerpt">Discover the most powerful features of modern JavaScript and how they can improve your development workflow.</p>
                    <a href="#" class="read-more">Read More →</a>
                </div>
            </div>
            
            <!-- Featured Post 3 -->
            <div class="post-card">
                <img src="https://source.unsplash.com/random/600x400/?cybersecurity" alt="Blog post thumbnail" class="post-image">
                <div class="post-content">
                    <h3 class="post-title">Essential Cybersecurity Practices</h3>
                    <span class="post-date">September 8, 2023</span>
                    <p class="post-excerpt">Protect your digital assets with these fundamental cybersecurity practices every developer should implement.</p>
                    <a href="#" class="read-more">Read More →</a>
                </div>
            </div>
        </div>
        
        <a href="/" class="back-link">← Back to Homepage</a>
    </div>
</body>
</html>
EOL

echo "Featured posts section has been successfully set up!" 