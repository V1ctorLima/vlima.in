import React from "react"
import { Link, graphql } from "gatsby"

import Layout from "../components/Layout"
import Seo from "../components/Seo"
import TagList from "../components/TagList"

const TagTemplate = ({ pageContext, data, location }) => {
  const { tag } = pageContext
  const { edges, totalCount } = data.allMdx
  const siteTitle = data.site.siteMetadata?.title || `Title`
  
  const tagHeader = `${totalCount} post${
    totalCount === 1 ? "" : "s"
  } tagged with "${tag}"`

  return (
    <Layout location={location} title={siteTitle}>
      <div>
        <h1 style={{ 
          fontSize: "2.5rem", 
          marginBottom: "1rem",
          letterSpacing: "-0.02em"
        }}>{tagHeader}</h1>
        
        <TagList tags={data.allTags.group.map(tag => tag.fieldValue)} style={{ marginBottom: "2rem" }} />
        
        <ol className="post-list" style={{ margin: 0 }}>
          {edges.map(({ node }) => {
            const title = node.frontmatter.title || node.fields?.slug
            
            return (
              <li key={node.id}>
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
                      <Link to={`/blog/${node.frontmatter.slug}`} itemProp="url">
                        <span itemProp="headline">{title}</span>
                      </Link>
                    </h2>
                    <small className="post-date">{node.frontmatter.date}</small>
                    
                    {node.frontmatter.tags && node.frontmatter.tags.length > 0 && (
                      <TagList tags={node.frontmatter.tags} style={{ marginTop: "0.75rem" }} />
                    )}
                  </header>
                  <section>
                    <p
                      dangerouslySetInnerHTML={{
                        __html: node.frontmatter.description || node.excerpt,
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
        
        <div style={{ marginTop: "3rem" }}>
          <Link 
            to="/tags"
            style={{
              border: "1px solid var(--color-border)",
              padding: "0.75rem 1.5rem",
              borderRadius: "2px",
              fontWeight: "500",
              display: "inline-block",
              fontFamily: "var(--font-sans)",
              fontSize: "1rem",
              marginRight: "1rem"
            }}
          >
            All Tags
          </Link>
          
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
            All Posts
          </Link>
        </div>
      </div>
    </Layout>
  )
}

export const Head = ({ pageContext }) => <Seo title={`Posts tagged with "${pageContext.tag}"`} />

export const pageQuery = graphql`
  query($tag: String) {
    site {
      siteMetadata {
        title
      }
    }
    allMdx(
      limit: 2000
      sort: { frontmatter: { date: DESC } }
      filter: { frontmatter: { tags: { in: [$tag] } } }
    ) {
      totalCount
      edges {
        node {
          id
          excerpt(pruneLength: 160)
          frontmatter {
            title
            date(formatString: "MMMM DD, YYYY")
            description
            slug
            tags
          }
        }
      }
    }
    allTags: allMdx {
      group(field: { frontmatter: { tags: SELECT } }) {
        fieldValue
      }
    }
  }
`

export default TagTemplate 