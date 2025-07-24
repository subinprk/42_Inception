#!/bin/bash

cd /var/www/html

# Use environment variables with defaults
DB_HOST=${WORDPRESS_DB_HOST:-mariadb}
DB_NAME=${WORDPRESS_DB_NAME:-wordpress}
DB_USER=${WORDPRESS_DB_USER:-wpuser}
DB_PASS=${WORDPRESS_DB_PASSWORD:-password}

echo "Waiting for database to be ready..."
# Wait for database to be ready
for i in {30..0}; do
    if mysql -h"$DB_HOST" -u"$DB_USER" -p"$DB_PASS" "$DB_NAME" -e 'SELECT 1' >/dev/null 2>&1; then
        echo "Database is ready!"
        break
    fi
    echo "Waiting for database... ($i seconds remaining)"
    sleep 1
done

if [ "$i" = 0 ]; then
    echo "Database failed to become ready!"
    exit 1
fi

# Check if WordPress is already installed
if [ ! -f wp-config.php ]; then
    echo "Installing WordPress..."
    
    # Clean up any existing WordPress files to avoid conflicts
    rm -rf *
    
    # Download wp-cli using the official method
    curl -L https://github.com/wp-cli/wp-cli/releases/download/v2.10.0/wp-cli-2.10.0.phar -o wp-cli.phar
    chmod +x wp-cli.phar
    
    # Download WordPress core
    ./wp-cli.phar core download --allow-root
    
    # Create wp-config.php
    ./wp-cli.phar config create \
        --dbname="$DB_NAME" \
        --dbuser="$DB_USER" \
        --dbpass="$DB_PASS" \
        --dbhost="$DB_HOST" \
        --allow-root
    
    # Install WordPress
    ./wp-cli.phar core install \
        --url=localhost \
        --title="Subin Inception" \
        --admin_user=admin \
        --admin_password=admin \
        --admin_email=admin@admin.com \
        --allow-root
    
    echo "WordPress installation completed!"
else
    echo "WordPress already installed."
fi

# Ensure correct permissions
chown -R www-data:www-data /var/www/html

echo "Starting PHP-FPM..."
php-fpm7.4 -F