/**
 * @type {import('gatsby').GatsbyNode['createPages']}
 */
exports.createPages = async ({ graphql, actions, reporter }) => {
  const { createPage } = actions

  // Define templates
  const blogPost = require.resolve(`./src/templates/blog-post.js`)
  const pageTemplate = require.resolve(`./src/templates/page.js`)
  const tagTemplate = require.resolve(`./src/templates/tag.js`)

  // Get all markdown blog posts sorted by date
  const blogResult = await graphql(`
    {
      allMdx(
        sort: { frontmatter: { date: ASC } }
        filter: { 
          frontmatter: { slug: { ne: null } }
          internal: { contentFilePath: { regex: "/content/blog/" } }
        }
      ) {
        nodes {
          id
          frontmatter {
            slug
            tags
          }
          internal {
            contentFilePath
          }
        }
      }
    }
  `)

  if (blogResult.errors) {
    reporter.panicOnBuild(
      `There was an error loading your blog posts`,
      blogResult.errors
    )
    return
  }

  const posts = blogResult.data.allMdx.nodes

  // Create blog posts pages
  if (posts.length > 0) {
    posts.forEach((post, index) => {
      const previousPostId = index === 0 ? null : posts[index - 1].id
      const nextPostId = index === posts.length - 1 ? null : posts[index + 1].id

      createPage({
        path: `/blog/${post.frontmatter.slug}`,
        component: `${blogPost}?__contentFilePath=${post.internal.contentFilePath}`,
        context: {
          id: post.id,
          previousPostId,
          nextPostId,
        },
      })
    })
  }

  // Get all markdown pages
  const pagesResult = await graphql(`
    {
      allMdx(
        filter: { 
          internal: { contentFilePath: { regex: "/content/pages/" } }
          frontmatter: { slug: { ne: null } }
        }
      ) {
        nodes {
          id
          frontmatter {
            slug
            title
          }
          internal {
            contentFilePath
          }
        }
      }
    }
  `)

  if (pagesResult.errors) {
    reporter.panicOnBuild(
      `There was an error loading your pages`,
      pagesResult.errors
    )
    return
  }

  const pages = pagesResult.data.allMdx.nodes

  // Create pages from markdown
  if (pages.length > 0) {
    pages.forEach(page => {
      createPage({
        path: page.frontmatter.slug,
        component: `${pageTemplate}?__contentFilePath=${page.internal.contentFilePath}`,
        context: {
          id: page.id,
        },
      })
    })
  }

  // Extract tag data from posts
  const tagsResult = await graphql(`
    {
      tagsGroup: allMdx(limit: 2000) {
        group(field: { frontmatter: { tags: SELECT } }) {
          fieldValue
        }
      }
    }
  `)

  if (tagsResult.errors) {
    reporter.panicOnBuild(`There was an error loading tags`, tagsResult.errors)
    return
  }

  // Create tag pages
  const tags = tagsResult.data.tagsGroup.group

  // Make tag pages
  tags.forEach(tag => {
    createPage({
      path: `/tags/${tag.fieldValue.toLowerCase().replace(/\s+/g, '-')}`,
      component: tagTemplate,
      context: {
        tag: tag.fieldValue,
      },
    })
  })
}

/**
 * @type {import('gatsby').GatsbyNode['createSchemaCustomization']}
 */
exports.createSchemaCustomization = ({ actions }) => {
  const { createTypes } = actions

  // Define the MdxFrontmatter type with optional fields
  createTypes(`
    type MdxFrontmatter {
      title: String
      date: Date @dateformat
      description: String
      slug: String
      featuredImage: File @fileByRelativePath
      tags: [String]
    }
  `)
} 