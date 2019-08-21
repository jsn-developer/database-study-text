FROM nginx

# Copy files
ADD _book /usr/share/nginx/html

EXPOSE 80

# ENTRYPOINT nginx -s reload