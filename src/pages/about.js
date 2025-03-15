import * as React from "react"
import { graphql } from "gatsby"

import Layout from "../components/Layout"
import Seo from "../components/Seo"

const AboutPage = ({ data, location }) => {
  return (
    <Layout location={location} title="About Me">
      <div className="page">
        <h1 className="page-title">About Me</h1>
        
        <div className="page-content">
          <p>
            I'm <strong>Victor Lima</strong>, a Security Engineer with a passion for building robust security solutions and sharing knowledge with the community.
          </p>
          
          <h2>Professional Background</h2>
          
          <p>
            I've built my career in cybersecurity, focusing primarily on Blue Team operations. My experience spans multiple domains:
          </p>
          
          <ul>
            <li><strong>Detection Engineering</strong>: Developing and implementing detection strategies for security threats</li>
            <li><strong>Incident Response</strong>: Investigating and mitigating security incidents</li>
            <li><strong>Cloud Security</strong>: Securing cloud infrastructure and applications</li>
            <li><strong>Corporate Security</strong>: Implementing enterprise-wide security policies and controls</li>
            <li><strong>Application Security</strong>: Ensuring software security throughout the development lifecycle</li>
          </ul>
          
          <h2>Technical Skills</h2>
          
          <ul>
            <li>Programming: Python, Bash, Javascript</li>
            <li>Cloud Platforms: AWS, Azure, GCP</li>
            <li>Security Tools: SIEM, EDR, IDS/IPS</li>
            <li>Operating Systems: Linux, Windows</li>
            <li>Containerization: Docker, Kubernetes</li>
          </ul>
          
          <h2>Current Focus</h2>
          
          <p>Currently, I'm focused on:</p>
          
          <ol>
            <li><strong>SOC Automation</strong>: Streamlining Security Operations Center processes using Python and Bash</li>
            <li><strong>Advanced Threat Detection</strong>: Implementing machine learning and User and Entity Behavior Analytics (UEBA) for improved threat detection</li>
            <li><strong>Continuous Learning</strong>: Expanding my knowledge in offensive security, vulnerability research, and bug hunting</li>
          </ol>
          
          <h2>Beyond Work</h2>
          
          <p>When I'm not working on security challenges, I enjoy:</p>
          
          <ul>
            <li>Contributing to open-source security projects</li>
            <li>Participating in CTF competitions</li>
            <li>Exploring new technologies and programming languages</li>
            <li>Sharing knowledge through blog posts and technical articles</li>
          </ul>
          
          <h2>Connect With Me</h2>
          
          <p>Feel free to reach out through any of these channels:</p>
          
          <ul>
            <li><a href="https://github.com/V1ctorLima">GitHub</a></li>
            <li><a href="https://www.linkedin.com/in/victorlimasec">LinkedIn</a></li>
            <li>Email: me@vlima.in</li>
          </ul>
          
          <p>I'm always open to interesting conversations, collaboration opportunities, and new connections in the security community.</p>
        </div>
      </div>
    </Layout>
  )
}

export const Head = () => <Seo title="About Me" />

export default AboutPage 