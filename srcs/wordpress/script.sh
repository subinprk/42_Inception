#!/bin/bash
cd /var/www/html

# Wait for MariaDB to be ready
echo "Waiting for MariaDB to be ready..."
while ! mysqladmin ping -h mariadb -u ${MYSQL_USER} -p${MYSQL_PASSWORD} --silent; do
    echo "MariaDB is not ready yet. Waiting..."
    sleep 2
done
echo "MariaDB is ready!"

# Download wp-cli if not exists
if [ ! -f wp-cli.phar ]; then
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
fi

# Download WordPress core if not exists
if [ ! -f wp-config.php ]; then
    ./wp-cli.phar core download --allow-root
    
    # Create wp-config.php using environment variables
    ./wp-cli.phar config create \
        --dbname=${MYSQL_DATABASE} \
        --dbuser=${MYSQL_USER} \
        --dbpass=${MYSQL_PASSWORD} \
        --dbhost=mariadb \
        --allow-root
    
    # Install WordPress using environment variables
    ./wp-cli.phar core install \
        --url=${WP_URL} \
        --title="${WP_TITLE}" \
        --admin_user=${WP_ADMIN_USER} \
        --admin_password=${WP_ADMIN_PASSWORD} \
        --admin_email=${WP_ADMIN_EMAIL} \
        --allow-root
fi

# Start PHP-FPM
exec php-fpm7.4 -F