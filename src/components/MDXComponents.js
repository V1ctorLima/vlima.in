import React from "react"
import { MDXProvider } from "@mdx-js/react"
import Panel from "./Panel"

// Define shortcode components
const components = {
  Panel,
  InfoPanel: (props) => <Panel type="info" {...props} />,
  WarningPanel: (props) => <Panel type="warning" {...props} />,
  DangerPanel: (props) => <Panel type="danger" {...props} />,
  SuccessPanel: (props) => <Panel type="success" {...props} />,
  NotePanel: (props) => <Panel type="note" {...props} />,
  // Add standard HTML elements to ensure they work correctly
  h1: props => <h1 {...props} />,
  h2: props => <h2 {...props} />,
  h3: props => <h3 {...props} />,
  h4: props => <h4 {...props} />,
  h5: props => <h5 {...props} />,
  h6: props => <h6 {...props} />,
  p: props => <p {...props} />,
  ul: props => <ul {...props} />,
  ol: props => <ol {...props} />,
  li: props => <li {...props} />,
  a: props => <a {...props} />,
  blockquote: props => <blockquote {...props} />,
  code: props => <code {...props} />,
  pre: props => <pre {...props} />,
}

export const MDXComponentsProvider = ({ children }) => {
  return <MDXProvider components={components}>{children}</MDXProvider>
}

export default components 