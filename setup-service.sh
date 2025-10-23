#!/bin/bash

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SERVICE_NAME="vlimain"
SERVICE_FILE="/etc/systemd/system/${SERVICE_NAME}.service"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to print colored output
print_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to check if running as root
check_root() {
    if [ "$EUID" -ne 0 ]; then
        print_error "This script must be run as root or with sudo"
        exit 1
    fi
}

# Function to check if Docker is installed
check_docker() {
    if ! command -v docker &> /dev/null; then
        print_error "Docker is not installed. Please install Docker first."
        exit 1
    fi
    print_success "Docker is installed"
}

# Function to check if Apache is running and disable it
handle_apache() {
    print_info "Checking for Apache..."
    
    # Check for apache2 or httpd
    if systemctl is-active --quiet apache2 2>/dev/null; then
        print_warning "Apache2 is running and will conflict with ports 80/443"
        read -p "Do you want to stop and disable Apache2? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            print_info "Stopping Apache2..."
            systemctl stop apache2
            print_info "Disabling Apache2..."
            systemctl disable apache2
            print_success "Apache2 has been stopped and disabled"
        else
            print_warning "Apache2 is still running. This may cause port conflicts!"
        fi
    elif systemctl is-active --quiet httpd 2>/dev/null; then
        print_warning "httpd is running and will conflict with ports 80/443"
        read -p "Do you want to stop and disable httpd? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            print_info "Stopping httpd..."
            systemctl stop httpd
            print_info "Disabling httpd..."
            systemctl disable httpd
            print_success "httpd has been stopped and disabled"
        else
            print_warning "httpd is still running. This may cause port conflicts!"
        fi
    else
        print_success "No Apache service found running"
    fi
}

# Function to create the systemd service file
create_service_file() {
    print_info "Creating systemd service file at ${SERVICE_FILE}..."
    
    cat > "${SERVICE_FILE}" << EOF
[Unit]
Description=Victor Lima Website Docker Container
Requires=docker.service
After=docker.service network-online.target
Wants=network-online.target

[Service]
Type=oneshot
RemainAfterExit=yes
WorkingDirectory=${SCRIPT_DIR}
ExecStartPre=/usr/bin/docker compose down
ExecStart=/usr/bin/docker compose up -d
ExecStop=/usr/bin/docker compose down
ExecReload=/usr/bin/docker compose restart
Restart=on-failure
RestartSec=10s
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

    if [ $? -eq 0 ]; then
        print_success "Service file created successfully"
    else
        print_error "Failed to create service file"
        exit 1
    fi
}

# Function to reload systemd and enable service
setup_service() {
    print_info "Reloading systemd daemon..."
    systemctl daemon-reload
    
    print_info "Enabling ${SERVICE_NAME} service..."
    systemctl enable "${SERVICE_NAME}.service"
    
    if [ $? -eq 0 ]; then
        print_success "Service enabled successfully"
    else
        print_error "Failed to enable service"
        exit 1
    fi
}

# Function to start the service
start_service() {
    print_info "Starting ${SERVICE_NAME} service..."
    systemctl start "${SERVICE_NAME}.service"
    
    if [ $? -eq 0 ]; then
        print_success "Service started successfully"
    else
        print_error "Failed to start service"
        print_info "Check logs with: journalctl -u ${SERVICE_NAME}.service -n 50"
        exit 1
    fi
}

# Function to verify the service
verify_service() {
    print_info "Verifying service status..."
    
    # Check if service is enabled
    if systemctl is-enabled --quiet "${SERVICE_NAME}.service"; then
        print_success "Service is enabled (will start on boot)"
    else
        print_warning "Service is not enabled"
    fi
    
    # Check if service is active
    if systemctl is-active --quiet "${SERVICE_NAME}.service"; then
        print_success "Service is active and running"
    else
        print_warning "Service is not active"
    fi
    
    # Check Docker containers
    print_info "Checking Docker containers..."
    sleep 2
    CONTAINER_COUNT=$(docker ps --filter "name=${SERVICE_NAME}" --format "{{.Names}}" | wc -l)
    
    if [ "$CONTAINER_COUNT" -gt 0 ]; then
        print_success "Docker containers are running:"
        docker ps --filter "name=${SERVICE_NAME}" --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    else
        print_warning "No Docker containers found running"
    fi
    
    # Test website
    print_info "Testing website response..."
    HTTP_CODE=$(curl -s -o /dev/null -w "%{http_code}" http://localhost 2>/dev/null)
    if [ "$HTTP_CODE" = "200" ] || [ "$HTTP_CODE" = "301" ] || [ "$HTTP_CODE" = "302" ]; then
        print_success "Website is responding (HTTP ${HTTP_CODE})"
    else
        print_warning "Website returned HTTP ${HTTP_CODE}"
    fi
}

# Function to show service management commands
show_commands() {
    echo ""
    echo -e "${GREEN}=== Service Setup Complete ===${NC}"
    echo ""
    echo "Useful commands for managing your service:"
    echo ""
    echo -e "${BLUE}Check service status:${NC}"
    echo "  sudo systemctl status ${SERVICE_NAME}.service"
    echo ""
    echo -e "${BLUE}View logs:${NC}"
    echo "  sudo journalctl -u ${SERVICE_NAME}.service -f"
    echo ""
    echo -e "${BLUE}Restart service:${NC}"
    echo "  sudo systemctl restart ${SERVICE_NAME}.service"
    echo ""
    echo -e "${BLUE}Stop service:${NC}"
    echo "  sudo systemctl stop ${SERVICE_NAME}.service"
    echo ""
    echo -e "${BLUE}Start service:${NC}"
    echo "  sudo systemctl start ${SERVICE_NAME}.service"
    echo ""
    echo -e "${BLUE}Disable service (prevent auto-start):${NC}"
    echo "  sudo systemctl disable ${SERVICE_NAME}.service"
    echo ""
    echo -e "${BLUE}Check Docker containers:${NC}"
    echo "  docker ps"
    echo ""
    echo -e "${GREEN}Your website will now automatically start on system reboot!${NC}"
    echo ""
}

# Main execution
main() {
    echo -e "${GREEN}╔════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}║   vlima.in Systemd Service Setup Script              ║${NC}"
    echo -e "${GREEN}╚════════════════════════════════════════════════════════╝${NC}"
    echo ""
    
    check_root
    check_docker
    handle_apache
    
    echo ""
    print_info "Working directory: ${SCRIPT_DIR}"
    echo ""
    
    # Confirmation
    read -p "Do you want to proceed with the service setup? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        print_warning "Setup cancelled by user"
        exit 0
    fi
    
    create_service_file
    setup_service
    start_service
    
    echo ""
    verify_service
    show_commands
}

# Run main function
main

