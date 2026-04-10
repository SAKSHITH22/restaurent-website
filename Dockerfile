# Use Nginx to serve the static restaurant website
FROM nginx:1.25-alpine

# Remove default Nginx static content and default config
RUN rm -rf /usr/share/nginx/html/* \
    && rm -f /etc/nginx/conf.d/default.conf

# Copy custom Nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy website files to Nginx html directory
COPY . /usr/share/nginx/html/

# Remove nginx.conf from web root to prevent information disclosure
RUN rm -f /usr/share/nginx/html/nginx.conf

# Expose port 80
EXPOSE 80

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
