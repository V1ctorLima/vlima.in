import React from "react"
import { graphql } from "gatsby"

import Layout from "../components/Layout"
import Seo from "../components/Seo"
import TagList from "../components/TagList"

const TagsPage = ({ data, location }) => {
  const siteTitle = data.site.siteMetadata?.title || `Title`
  const tags = data.allMdx.group.map(tag => tag.fieldValue)

  return (
    <Layout location={location} title={siteTitle}>
      <div>
        <h1 style={{ 
          fontSize: "2.5rem", 
          marginBottom: "2rem",
          letterSpacing: "-0.02em"
        }}>Tags</h1>
        
        <p style={{ 
          fontSize: "1.2rem", 
          marginBottom: "3rem", 
          maxWidth: "700px",
          lineHeight: "1.7"
        }}>
          Browse all topics I write about. Click on a tag to see all posts related to that topic.
        </p>
        
        <div style={{ marginBottom: "3rem" }}>
          <TagList tags={tags} />
        </div>
        
        <div>
          <h2 style={{ 
            fontSize: "1.8rem", 
            marginBottom: "1.5rem",
            letterSpacing: "-0.015em"
          }}>Tag Statistics</h2>
          
          <ul style={{ 
            listStyle: "none", 
            padding: 0,
            display: "grid",
            gridTemplateColumns: "repeat(auto-fill, minmax(250px, 1fr))",
            gap: "1rem"
          }}>
            {data.allMdx.group.map(tag => (
              <li key={tag.fieldValue} style={{
                padding: "1rem",
                backgroundColor: "var(--color-card-background)",
                borderRadius: "var(--border-radius)",
                border: "1px solid var(--color-border)"
              }}>
                <div style={{ 
                  display: "flex", 
                  justifyContent: "space-between",
                  alignItems: "center"
                }}>
                  <TagList tags={[tag.fieldValue]} />
                  <span style={{ 
                    backgroundColor: "var(--color-primary)",
                    color: "white",
                    borderRadius: "1rem",
                    padding: "0.25rem 0.75rem",
                    fontSize: "0.85rem",
                    fontWeight: "bold"
                  }}>
                    {tag.totalCount}
                  </span>
                </div>
              </li>
            ))}
          </ul>
        </div>
      </div>
    </Layout>
  )
}

export const Head = () => <Seo title="All Tags" />

export const pageQuery = graphql`
  query {
    site {
      siteMetadata {
        title
      }
    }
    allMdx {
      group(field: { frontmatter: { tags: SELECT } }) {
        fieldValue
        totalCount
      }
    }
  }
`

export default TagsPage 