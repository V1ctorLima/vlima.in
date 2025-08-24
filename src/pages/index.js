import * as React from "react"
import { Link, graphql } from "gatsby"
import { StaticImage } from "gatsby-plugin-image"

import Layout from "../components/Layout"
import Seo from "../components/Seo"
import TagList from "../components/TagList"

const IndexPage = ({ data, location }) => {
  const siteTitle = data.site.siteMetadata?.title || `Title`
  // Filter out posts without a slug and ensure they're from the blog directory
  const posts = data.allMdx.nodes.filter(post => 
    post.frontmatter.slug && 
    post.internal.contentFilePath.includes('/blog/')
  );

  return (
    <Layout location={location} title={siteTitle}>
      <div className="home-hero">
        <div className="hero-content">
          <div className="profile-image-container">
            <StaticImage
              src="../images/avatar_redondo2.jpeg"
              alt="Victor Lima"
              placeholder="blurred"
              layout="fixed"
              width={200}
              height={200}
              className="profile-image"
              imgStyle={{ borderRadius: "50%" }}
            />
          </div>
          <h1 style={{ 
            fontSize: "3rem", 
            marginBottom: "1.5rem",
            letterSpacing: "-0.03em",
            lineHeight: "1.2",
            textAlign: "center"
          }}>
            Hi, I'm Victor Lima
          </h1>
          <p style={{ 
            fontSize: "1.3rem", 
            maxWidth: "600px", 
            marginBottom: "2rem",
            lineHeight: "1.7",
            color: "var(--color-text)",
            textAlign: "center",
            margin: "0 auto 2rem auto"
          }}>
            Security engineer and technology enthusiast. I write about security,
            detection engineering, software development, and share my experiences in the tech industry.
          </p>
          <div className="hero-buttons" style={{ textAlign: "center" }}>
            <Link 
              to="/blog" 
              style={{
                background: "var(--color-primary)",
                color: "white",
                padding: "0.75rem 1.5rem",
                borderRadius: "2px",
                fontWeight: "500",
                marginRight: "1.5rem",
                display: "inline-block",
                fontFamily: "var(--font-sans)",
                fontSize: "1rem"
              }}
            >
              Read My Blog
            </Link>
            <Link 
              to="/about"
              style={{
                border: "1px solid var(--color-border)",
                padding: "0.75rem 1.5rem",
                borderRadius: "2px",
                fontWeight: "500",
                display: "inline-block",
                fontFamily: "var(--font-sans)",
                fontSize: "1rem"
              }}
            >
              About Me
            </Link>
          </div>
        </div>
      </div>
      
      <div style={{ marginTop: "5rem" }}>
        <h2 style={{ 
          fontSize: "2rem", 
          marginBottom: "1.5rem",
          letterSpacing: "-0.015em"
        }}>Latest Posts</h2>
        <div className="post-grid" style={{ 
          display: "grid", 
          gridTemplateColumns: "repeat(auto-fill, minmax(300px, 1fr))", 
          gap: "2rem",
          marginTop: "2rem"
        }}>
          {posts.length > 0 ? (
            posts.map(post => (
              <Link 
                to={`/blog/${post.frontmatter.slug}`} 
                key={post.id}
                style={{ textDecoration: "none", color: "inherit" }}
              >
                <div className="post-list-item">
                  <h3 className="post-title" style={{ 
                    fontSize: "1.4rem", 
                    marginBottom: "0.5rem",
                    letterSpacing: "-0.01em"
                  }}>{post.frontmatter.title}</h3>
                  <p className="post-date">{post.frontmatter.date}</p>
                  
                  {post.frontmatter.tags && post.frontmatter.tags.length > 0 && (
                    <TagList tags={post.frontmatter.tags} style={{ marginTop: "0.5rem", marginBottom: "0.5rem" }} />
                  )}
                  
                  <p style={{ fontSize: "1.1rem", lineHeight: "1.6" }}>
                    {post.frontmatter.description || post.excerpt}
                  </p>
                </div>
              </Link>
            ))
          ) : (
            <p>No blog posts found. Start writing your first post in the content/blog directory.</p>
          )}
        </div>
        {posts.length > 0 && (
          <div style={{ textAlign: "center", marginTop: "3rem" }}>
            <Link 
              to="/blog"
              style={{
                border: "1px solid var(--color-border)",
                padding: "0.75rem 1.5rem",
                borderRadius: "2px",
                fontWeight: "500",
                display: "inline-block",
                fontFamily: "var(--font-sans)",
                fontSize: "1rem"
              }}
            >
              View All Posts
            </Link>
          </div>
        )}
      </div>
    </Layout>
  )
}

export const Head = () => <Seo title="Home" />

export const pageQuery = graphql`
  query {
    site {
      siteMetadata {
        title
      }
    }
    allMdx(
      sort: { frontmatter: { date: DESC } }
      limit: 3
    ) {
      nodes {
        excerpt
        id
        internal {
          contentFilePath
        }
        frontmatter {
          date(formatString: "MMMM DD, YYYY")
          title
          slug
          description
          tags
        }
      }
    }
  }
`

export default IndexPage 