# Build stage
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy all files
COPY . .

# Build the Gatsby site
RUN npm run build

# Serve stage
FROM nginx:alpine

# Install dependencies
RUN apk add --no-cache bash openssl

# Copy the built Gatsby site
COPY public /usr/share/nginx/html

# Create directories for SSL certificates
RUN mkdir -p /etc/nginx/ssl

# Create directories for Nginx configuration
RUN mkdir -p /etc/nginx/conf.d

# Copy Nginx configuration template
COPY nginx/nginx.conf /etc/nginx/nginx.conf

# Copy the entrypoint script
COPY nginx/entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Expose ports
EXPOSE 80 443

# Set the entrypoint script
ENTRYPOINT ["/entrypoint.sh"]

# Start Nginx
CMD ["nginx", "-g", "daemon off;"] 