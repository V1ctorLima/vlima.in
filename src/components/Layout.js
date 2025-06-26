import React from "react"
import { Link } from "gatsby"
import "../styles/layout.css"
import "@fortawesome/fontawesome-free/css/all.min.css"
import githubIcon from "../images/icons8-github.gif"
import linkedinIcon from "../images/icons8-linkedin-50.png"
import emailIcon from "../images/icons8-mail.gif"
import rssIcon from "../images/icons8-rss-96.png"

const Layout = ({ location, title, children }) => {
  const rootPath = `${__PATH_PREFIX__}/`
  const isRootPath = location.pathname === rootPath
  
  return (
    <div className="global-wrapper" data-is-root-path={isRootPath}>
      <header className="global-header">
        <div className="header-content">
          <div className="header-left">
            {isRootPath ? (
              <h1 className="main-heading">
                <Link to="/">{title}</Link>
              </h1>
            ) : (
              <h3 className="header-link-home">
                <Link to="/">{title}</Link>
              </h3>
            )}
          </div>
          
          <div className="header-right">
            <div className="header-row">
              <div className="social-icons">
                <a href="https://github.com/V1ctorLima" className="social-icon" target="_blank" rel="noopener noreferrer">
                  <img src={githubIcon} alt="GitHub" />
                </a>
                <a href="https://www.linkedin.com/in/victorlimasec/" className="social-icon" target="_blank" rel="noopener noreferrer">
                  <img src={linkedinIcon} alt="LinkedIn" />
                </a>
                <a href="javascript:location.href = 'mailto:' + ['me','vlima.in'].join('@')" className="social-icon" target="_blank" rel="noopener noreferrer">
                  <img src={emailIcon} alt="Email" />
                </a>
                <a href="/rss.xml" className="social-icon" target="_blank" rel="noopener noreferrer">
                  <img src={rssIcon} alt="RSS" />
                </a>
              </div>
            </div>
            <div className="header-row">
              <nav className="nav-links">
                <Link to="/">Home</Link>
                <Link to="/blog">Blog</Link>
                <Link to="/tags">Tags</Link>
                <Link to="/about">About</Link>
              </nav>
            </div>
          </div>
        </div>
      </header>
      <main>{children}</main>
      <footer>
        © 2023 - {new Date().getFullYear()}
      </footer>
    </div>
  )
}

export default Layout 