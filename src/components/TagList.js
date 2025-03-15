import React from "react"
import Tag from "./Tag"

const TagList = ({ tags, style = {} }) => {
  if (!tags || tags.length === 0) return null
  
  return (
    <div style={{ display: "flex", flexWrap: "wrap", ...style }}>
      {tags.map(tag => (
        <Tag key={tag} tag={tag} />
      ))}
    </div>
  )
}

export default TagList 