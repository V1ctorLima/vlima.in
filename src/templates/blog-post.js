import * as React from "react"
import { Link, graphql } from "gatsby"
import { GatsbyImage, getImage } from "gatsby-plugin-image"

import Layout from "../components/Layout"
import Seo from "../components/Seo"
import TagList from "../components/TagList"

const BlogPostTemplate = ({
  data: { previous, next, site, mdx: post },
  children,
  location,
}) => {
  const siteTitle = site.siteMetadata?.title || `Title`
  const featuredImage = post.frontmatter.featuredImage 
    ? getImage(post.frontmatter.featuredImage) 
    : null

  return (
    <Layout location={location} title={siteTitle}>
      <article
        className="blog-post"
        itemScope
        itemType="http://schema.org/Article"
      >
        <header className="blog-post-header">
          <h1 className="blog-post-title" itemProp="headline">{post.frontmatter.title}</h1>
          <p className="blog-post-date">{post.frontmatter.date}</p>
          
          {post.frontmatter.tags && post.frontmatter.tags.length > 0 && (
            <TagList tags={post.frontmatter.tags} style={{ marginTop: "1rem" }} />
          )}
          
          {featuredImage && (
            <div style={{ marginTop: "2rem" }}>
              <GatsbyImage
                image={featuredImage}
                alt={post.frontmatter.title}
                style={{ 
                  borderRadius: "var(--border-radius)",
                  maxHeight: "500px"
                }}
              />
            </div>
          )}
        </header>
        
        <section
          className="blog-post-content"
          itemProp="articleBody"
        >
          {children}
        </section>
        
        <hr style={{ 
          margin: "var(--spacing-xl) 0",
          border: "none",
          borderTop: "1px solid var(--color-border)"
        }} />
        
        <nav className="blog-post-nav">
          <ul
            style={{
              display: `flex`,
              flexWrap: `wrap`,
              justifyContent: `space-between`,
              listStyle: `none`,
              padding: 0,
            }}
          >
            <li>
              {previous && (
                <Link to={`/blog/${previous.frontmatter.slug}`} rel="prev">
                  ← {previous.frontmatter.title}
                </Link>
              )}
            </li>
            <li>
              {next && (
                <Link to={`/blog/${next.frontmatter.slug}`} rel="next">
                  {next.frontmatter.title} →
                </Link>
              )}
            </li>
          </ul>
        </nav>
      </article>
    </Layout>
  )
}

export const Head = ({ data: { mdx: post } }) => {
  return (
    <Seo
      title={post.frontmatter.title}
      description={post.frontmatter.description || post.excerpt}
    />
  )
}

export const pageQuery = graphql`
  query BlogPostBySlug(
    $id: String!
    $previousPostId: String
    $nextPostId: String
  ) {
    site {
      siteMetadata {
        title
      }
    }
    mdx(id: { eq: $id }) {
      id
      excerpt(pruneLength: 160)
      frontmatter {
        title
        date(formatString: "MMMM DD, YYYY")
        description
        tags
        featuredImage {
          childImageSharp {
            gatsbyImageData(
              width: 800
              placeholder: BLURRED
              formats: [AUTO, WEBP, AVIF]
            )
          }
        }
      }
    }
    previous: mdx(id: { eq: $previousPostId }) {
      frontmatter {
        title
        slug
      }
    }
    next: mdx(id: { eq: $nextPostId }) {
      frontmatter {
        title
        slug
      }
    }
  }
`

export default BlogPostTemplate 