import * as React from "react"

import Layout from "../components/Layout"
import Seo from "../components/Seo"

const PrivacyPage = ({ location }) => {
  return (
    <Layout location={location} title="Privacy Policy">
      <div className="page">
        <h1 className="page-title">Privacy Policy</h1>

        <div className="page-content">
          <p>
            <em>Last updated: March 5, 2026</em>
          </p>

          <p>
            This Privacy Policy applies to all applications developed and published by <strong>Victor Lima</strong> ("I", "me", or "my") on the Google Play Store and Apple App Store. This policy describes how I handle information in connection with my apps.
          </p>

          <h2>Information I Do Not Collect</h2>

          <p>
            My apps are designed with privacy in mind. By default, I do not collect, store, or share any personally identifiable information (PII) from users. This includes:
          </p>

          <ul>
            <li>Name, email address, or contact information</li>
            <li>Location data</li>
            <li>Device identifiers</li>
            <li>Usage data or analytics</li>
            <li>Financial or payment information</li>
          </ul>

          <h2>Third-Party Services</h2>

          <p>
            Some apps may integrate third-party services (such as analytics providers, advertising networks, or platform APIs). When used, these services may collect data subject to their own privacy policies. I will clearly disclose any such integrations within the specific app's description or in-app documentation.
          </p>

          <p>Common third-party services that may be used include:</p>

          <ul>
            <li><strong>Google Play Services</strong> — subject to <a href="https://policies.google.com/privacy" target="_blank" rel="noopener noreferrer">Google's Privacy Policy</a></li>
            <li><strong>Apple Services</strong> — subject to <a href="https://www.apple.com/legal/privacy/" target="_blank" rel="noopener noreferrer">Apple's Privacy Policy</a></li>
          </ul>

          <h2>Permissions</h2>

          <p>
            Some apps may request device permissions (e.g., camera, storage, internet access) solely to provide core functionality. These permissions are never used to collect or transmit personal data beyond what is necessary for the app to work.
          </p>

          <h2>Children's Privacy</h2>

          <p>
            My apps are not directed at children under the age of 13. I do not knowingly collect personal information from children. If you believe a child has provided personal information through one of my apps, please contact me so I can address it promptly.
          </p>

          <h2>Security</h2>

          <p>
            I take reasonable precautions to protect any data processed by my apps. However, no method of electronic storage or transmission is 100% secure, and I cannot guarantee absolute security.
          </p>

          <h2>Changes to This Policy</h2>

          <p>
            I may update this Privacy Policy from time to time. Any changes will be reflected by the "Last updated" date at the top of this page. Continued use of my apps after changes are posted constitutes acceptance of the updated policy.
          </p>

          <h2>Contact</h2>

          <p>
            If you have any questions or concerns about this Privacy Policy, feel free to contact me:
          </p>

          <ul>
            <li>Email: <a href="mailto:me@vlima.in">me@vlima.in</a></li>
          </ul>
        </div>
      </div>
    </Layout>
  )
}

export const Head = () => <Seo title="Privacy Policy" />

export default PrivacyPage
