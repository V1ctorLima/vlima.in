/**
 * @type {import('gatsby').GatsbyConfig}
 */
module.exports = {
  siteMetadata: {
    title: `Victor Lima`,
    description: `Personal website and blog with clean, minimalist design`,
    author: `Victor Lima`,
    siteUrl: `https://victorlima.com`,
  },
  plugins: [
    `gatsby-plugin-image`,
    `gatsby-plugin-sharp`,
    `gatsby-transformer-sharp`,
    {
      resolve: `gatsby-source-filesystem`,
      options: {
        name: `images`,
        path: `${__dirname}/src/images`,
      },
    },
    {
      resolve: `gatsby-source-filesystem`,
      options: {
        name: `blog`,
        path: `${__dirname}/content/blog`,
      },
    },
    {
      resolve: `gatsby-source-filesystem`,
      options: {
        name: `pages`,
        path: `${__dirname}/content/pages`,
      },
    },
    {
      resolve: `gatsby-plugin-mdx`,
      options: {
        extensions: [`.mdx`, `.md`],
        mdxOptions: {
          remarkPlugins: [],
          rehypePlugins: [],
        },
        gatsbyRemarkPlugins: [
          {
            resolve: `gatsby-remark-images`,
            options: {
              maxWidth: 800,
              quality: 90,
              linkImagesToOriginal: false,
            },
          },
        ],
      },
    },
    {
      resolve: `gatsby-plugin-feed`,
      options: {
        query: `
          {
            site {
              siteMetadata {
                title
                description
                siteUrl
                site_url: siteUrl
              }
            }
          }
        `,
        feeds: [
          {
            serialize: ({ query: { site, allMdx } }) => {
              return allMdx.nodes.map(node => {
                return Object.assign({}, node.frontmatter, {
                  description: node.frontmatter.description || node.excerpt,
                  date: node.frontmatter.date,
                  url: site.siteMetadata.siteUrl + '/blog/' + node.frontmatter.slug,
                  guid: site.siteMetadata.siteUrl + '/blog/' + node.frontmatter.slug,
                  custom_elements: [{ "content:encoded": node.body }],
                })
              })
            },
            query: `
              {
                allMdx(
                  filter: {
                    internal: { contentFilePath: { regex: "/content/blog/" } }
                    frontmatter: { title: { ne: null }, slug: { ne: null } }
                  }
                  sort: { frontmatter: { date: DESC } }
                ) {
                  nodes {
                    excerpt
                    body
                    frontmatter {
                      title
                      date
                      description
                      slug
                    }
                  }
                }
              }
            `,
            output: "/rss.xml",
            title: "Victor Lima's Blog RSS Feed",
            match: "^/blog/",
          },
        ],
      },
    },
    {
      resolve: `gatsby-plugin-google-gtag`,
      options: {
        trackingIds: [
          "G-H7MZ8PJ08S", // Google Analytics / GA
        ],
        },
      },
  ],
};