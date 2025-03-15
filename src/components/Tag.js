import React from "react"
import { Link } from "gatsby"

const Tag = ({ tag }) => {
  const slug = tag.toLowerCase().replace(/\s+/g, '-')
  
  return (
    <Link 
      to={`/tags/${slug}`}
      style={{
        display: "inline-block",
        backgroundColor: "var(--color-card-background)",
        color: "var(--color-text-light)",
        padding: "0.25rem 0.75rem",
        borderRadius: "1rem",
        fontSize: "0.85rem",
        marginRight: "0.5rem",
        marginBottom: "0.5rem",
        border: "1px solid var(--color-border)",
        textDecoration: "none",
        transition: "var(--transition)",
      }}
      activeStyle={{
        backgroundColor: "var(--color-primary)",
        color: "white",
        borderColor: "var(--color-primary)",
      }}
    >
      {tag}
    </Link>
  )
}

export default Tag 