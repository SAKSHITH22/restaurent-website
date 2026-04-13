# Production-ready Nginx image for the restaurant website
FROM nginx:1.25-alpine

# Add metadata
LABEL maintainer="SAKSHITH22" \
      description="Production restaurant website" \
      version="1.0"

# Install curl for healthchecks and remove cache
RUN apk add --no-cache curl \
    && rm -rf /usr/share/nginx/html/* \
    && rm -f /etc/nginx/conf.d/default.conf

# Copy custom Nginx config
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copy website files to Nginx html directory
COPY . /usr/share/nginx/html/

# Remove nginx.conf from web root to prevent information disclosure
RUN rm -f /usr/share/nginx/html/nginx.conf

# Container healthcheck
HEALTHCHECK --interval=30s --timeout=5s --start-period=10s --retries=3 \
    CMD curl -f http://localhost:80/ || exit 1

# Expose port 80
EXPOSE 80

# Start Nginx in the foreground
CMD ["nginx", "-g", "daemon off;"]
