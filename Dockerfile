# Stage 1: Use Nginx to serve the static restaurant website
FROM nginx:1.25-alpine

# Remove default Nginx static content
RUN rm -rf /usr/share/nginx/html/*

# Copy website files to Nginx html directory
COPY . /usr/share/nginx/html/

# Remove unnecessary files from the container
RUN rm -f /usr/share/nginx/html/Dockerfile \
    /usr/share/nginx/html/Jenkinsfile \
    /usr/share/nginx/html/deployment.yaml \
    /usr/share/nginx/html/service.yaml

# Expose port 80
EXPOSE 80

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
