import * as React from "react"
import { graphql } from "gatsby"

import Layout from "../components/Layout"
import Seo from "../components/Seo"

const PageTemplate = ({
  data: { site, mdx: page },
  children,
  location,
}) => {
  const siteTitle = site.siteMetadata?.title || `Title`

  return (
    <Layout location={location} title={siteTitle}>
      <article
        className="page"
        itemScope
        itemType="http://schema.org/Article"
      >
        <header className="page-header">
          <h1 className="page-title" itemProp="headline">{page.frontmatter.title}</h1>
        </header>
        
        <section
          className="page-content"
          itemProp="articleBody"
        >
          {children}
        </section>
      </article>
    </Layout>
  )
}

export const Head = ({ data: { mdx: page } }) => {
  return (
    <Seo
      title={page.frontmatter.title}
      description={page.frontmatter.description || page.excerpt}
    />
  )
}

export const pageQuery = graphql`
  query PageBySlug($id: String!) {
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
        description
        slug
      }
    }
  }
`

export default PageTemplate 