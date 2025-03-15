import React from "react"

const Panel = ({ children, type = "info", title }) => {
  // Define styles for different panel types
  const styles = {
    info: {
      borderColor: "#3498db",
      backgroundColor: "#ebf5fb",
      titleColor: "#3498db",
      iconClass: "fas fa-info-circle"
    },
    warning: {
      borderColor: "#f39c12",
      backgroundColor: "#fef5e7",
      titleColor: "#f39c12",
      iconClass: "fas fa-exclamation-triangle"
    },
    danger: {
      borderColor: "#e74c3c",
      backgroundColor: "#fdedeb",
      titleColor: "#e74c3c",
      iconClass: "fas fa-times-circle"
    },
    success: {
      borderColor: "#2ecc71",
      backgroundColor: "#eafaf1",
      titleColor: "#2ecc71",
      iconClass: "fas fa-check-circle"
    },
    note: {
      borderColor: "#9b59b6",
      backgroundColor: "#f4ecf7",
      titleColor: "#9b59b6",
      iconClass: "fas fa-sticky-note"
    }
  }

  const panelStyle = styles[type] || styles.info

  return (
    <div
      style={{
        border: `1px solid ${panelStyle.borderColor}`,
        borderLeft: `4px solid ${panelStyle.borderColor}`,
        backgroundColor: panelStyle.backgroundColor,
        borderRadius: "4px",
        padding: "16px",
        margin: "24px 0",
      }}
    >
      <div
        style={{
          display: "flex",
          alignItems: "center",
          marginBottom: title ? "8px" : "0",
        }}
      >
        <i
          className={panelStyle.iconClass}
          style={{
            color: panelStyle.titleColor,
            marginRight: "8px",
            fontSize: "18px",
          }}
        ></i>
        {title && (
          <h4
            style={{
              margin: 0,
              color: panelStyle.titleColor,
              fontWeight: "600",
              fontSize: "16px",
            }}
          >
            {title}
          </h4>
        )}
      </div>
      <div>{children}</div>
    </div>
  )
}

export default Panel 