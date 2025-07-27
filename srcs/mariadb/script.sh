#!/bin/bash

# Check if MySQL data directory is already initialized
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Initializing MariaDB data directory..."
    # Initialize the MySQL data directory (no need for --user since we're already running as mysql)
    mysql_install_db --basedir=/usr --datadir=/var/lib/mysql
    
    # Start MySQL service in the background
    mysqld_safe &
    
    # Wait for MySQL to start
    sleep 10
    
    echo "Setting up database and user..."
    echo "Environment variables: MYSQL_DATABASE=${MYSQL_DATABASE}, MYSQL_USER=${MYSQL_USER}, MYSQL_PASSWORD=${MYSQL_PASSWORD}"
    echo "MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD}"
    
    # Show the original file content
    echo "Original init.sql content:"
    cat /etc/mysql/init.sql
    
    # Process the init.sql file with environment variable substitution
    envsubst '${MYSQL_DATABASE} ${MYSQL_USER} ${MYSQL_PASSWORD}' < /etc/mysql/init.sql > /tmp/init_processed.sql
    
    echo "Generated SQL file content:"
    cat /tmp/init_processed.sql
    
    # Execute the SQL commands
    mysql -u root < /tmp/init_processed.sql
    
    # Set root password
    mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
    mysql -u root -e "FLUSH PRIVILEGES;"
    
    # Stop the background MySQL service
    mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown
    
    echo "MariaDB initialization complete."
else
    echo "MariaDB data directory already exists, skipping initialization."
fi

# Start MySQL in foreground
echo "Starting MariaDB..."
exec mysqld