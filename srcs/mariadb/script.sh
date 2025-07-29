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
    
    # Process the init.sql file with environment variable substitution
    envsubst  < /etc/mysql/init.sql > /tmp/init_processed.sql
    
    echo "Generated SQL file content:"
    cat /tmp/init_processed.sql
    
    # Execute the SQL commands
    mysql -u root < /tmp/init_processed.sql
    
    # Force wpuser to use password authentication
    mysql -u root -e "ALTER USER '${MYSQL_USER}'@'%' IDENTIFIED WITH mysql_native_password BY '${MYSQL_PASSWORD}'; FLUSH PRIVILEGES;"
    
    # Remove anonymous users and secure the installation
    mysql -u root -e "DELETE FROM mysql.user WHERE User=''; FLUSH PRIVILEGES;"
    
    # Set root password using mysqladmin (more reliable)
    echo "Password Setting"
    mysqladmin -u root password "${MYSQL_ROOT_PASSWORD}"
    mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"

    
    # Stop the background MySQL service
    mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown
    
    echo "MariaDB initialization complete."
else
    echo "MariaDB data directory already exists, skipping initialization."
fi

    # Set up a health check user
# mysql -u root -p${MYSQL_ROOT_PASSWORD} -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';"
# mysql -u root -e "ALTER USER '${MYSQL_USER}'@'localhost' IDENTIFIED WITH mysql_native_password BY '${MYSQL_PASSWORD}';"
# Start MySQL in foreground
echo "Starting MariaDB..."
exec mysqld