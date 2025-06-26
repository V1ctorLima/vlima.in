# Use a single-stage build for simplicity
FROM nginx:alpine

# Install dependencies
RUN apk add --no-cache bash openssl nodejs npm

# Set working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy all files
COPY . .

# Accept build arguments for environment variables
ARG GATSBY_GA_MEASUREMENT_ID
# Make the build arg available as environment variable during build
ENV GATSBY_GA_MEASUREMENT_ID=$GATSBY_GA_MEASUREMENT_ID

# Build the Gatsby site
RUN npm run build

# Copy the built site to Nginx's html directory
RUN cp -r public/* /usr/share/nginx/html/

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