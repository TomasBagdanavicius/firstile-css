# Use the official Nginx image
FROM nginx:latest

# Copy the custom Nginx configuration file
COPY nginx.conf /etc/nginx/nginx.conf

# Copy project files to the web root
COPY . /usr/share/nginx/html

# Ensure the correct permissions
RUN chown -R www-data:www-data /usr/share/nginx/html
RUN chmod -R 755 /usr/share/nginx/html

# Optionally, remove any default index.html file
RUN rm -f /usr/share/nginx/html/index.html

# Expose port 8082
EXPOSE 8082

# Start Nginx
CMD ["nginx", "-g", "daemon off;"]