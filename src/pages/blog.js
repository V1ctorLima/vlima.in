import * as React from "react"
import { Link, graphql } from "gatsby"

import Layout from "../components/Layout"
import Seo from "../components/Seo"
import TagList from "../components/TagList"

const BlogPage = ({ data, location }) => {
  const siteTitle = data.site.siteMetadata?.title || `Title`
  const posts = data.allMdx.nodes.filter(post => 
    post.frontmatter.slug && 
    post.internal.contentFilePath.includes('/blog/')
  );

  if (posts.length === 0) {
    return (
      <Layout location={location} title={siteTitle}>
        <h1 style={{ 
          fontSize: "2.5rem", 
          marginBottom: "2rem",
          letterSpacing: "-0.02em"
        }}>Blog</h1>
        <p style={{ 
          fontSize: "1.2rem", 
          lineHeight: "1.7"
        }}>
          No blog posts found. Start writing your first post in the content/blog directory.
        </p>
      </Layout>
    )
  }

  return (
    <Layout location={location} title={siteTitle}>
      <div>
        <h1 style={{ 
          fontSize: "2.5rem", 
          marginBottom: "2rem",
          letterSpacing: "-0.02em"
        }}>Blog</h1>
        <p style={{ 
          fontSize: "1.2rem", 
          marginBottom: "3rem", 
          maxWidth: "700px",
          lineHeight: "1.7"
        }}>
          Here you'll find all my blog posts. I write about software development, technology trends,
          and share my experiences in the tech industry.
        </p>
        
        <ol className="post-list" style={{ margin: 0 }}>
          {posts.map(post => {
            const title = post.frontmatter.title || post.fields?.slug

            return (
              <li key={post.id}>
                <article
                  className="post-list-item"
                  itemScope
                  itemType="http://schema.org/Article"
                >
                  <header>
                    <h2 className="post-title" style={{ 
                      fontSize: "1.8rem", 
                      marginBottom: "0.5rem",
                      letterSpacing: "-0.015em"
                    }}>
                      <Link to={`/blog/${post.frontmatter.slug}`} itemProp="url">
                        <span itemProp="headline">{title}</span>
                      </Link>
                    </h2>
                    <small className="post-date">{post.frontmatter.date}</small>
                    
                    {post.frontmatter.tags && post.frontmatter.tags.length > 0 && (
                      <TagList tags={post.frontmatter.tags} style={{ marginTop: "0.75rem" }} />
                    )}
                  </header>
                  <section>
                    <p
                      dangerouslySetInnerHTML={{
                        __html: post.frontmatter.description || post.excerpt,
                      }}
                      itemProp="description"
                      style={{ 
                        fontSize: "1.1rem", 
                        lineHeight: "1.7",
                        marginTop: "0.75rem"
                      }}
                    />
                  </section>
                </article>
              </li>
            )
          })}
        </ol>
      </div>
    </Layout>
  )
}

export const Head = () => <Seo title="Blog" />

export const pageQuery = graphql`
  query {
    site {
      siteMetadata {
        title
      }
    }
    allMdx(sort: { frontmatter: { date: DESC } }) {
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

export default BlogPage 