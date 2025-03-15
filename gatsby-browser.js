import React from "react"
import { MDXComponentsProvider } from "./src/components/MDXComponents"

// Wraps every page in a component
export const wrapPageElement = ({ element }) => {
  return <MDXComponentsProvider>{element}</MDXComponentsProvider>
} 