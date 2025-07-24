#!/bin/bash

# MariaDB initialization script
set -e

echo "Starting MariaDB initialization..."

# Set default values if environment variables are not set
MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-rootpassword}
MYSQL_DATABASE=${MYSQL_DATABASE:-wordpress}
MYSQL_USER=${MYSQL_USER:-wpuser}
MYSQL_PASSWORD=${MYSQL_PASSWORD:-password}

# Check if database is already initialized
if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Database not initialized. Initializing..."
    
    # Initialize MariaDB
    mysql_install_db --user=mysql --datadir=/var/lib/mysql
    
    # Start MariaDB temporarily
    mysqld_safe --user=mysql --skip-networking --socket=/run/mysqld/mysqld.sock &
    mysql_pid=$!
    
    # Wait for MariaDB to start
    echo "Waiting for MariaDB to start..."
    for i in {30..0}; do
        if mysqladmin ping --socket=/run/mysqld/mysqld.sock >/dev/null 2>&1; then
            break
        fi
        echo "Waiting for MariaDB... ($i seconds remaining)"
        sleep 1
    done
    
    if [ "$i" = 0 ]; then
        echo "MariaDB failed to start!"
        exit 1
    fi
    
    echo "MariaDB started. Running initialization SQL..."
    
    # Create the initialization SQL on the fly
    cat > /tmp/init.sql << EOF
-- Set root password
ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';

-- Create database
CREATE DATABASE IF NOT EXISTS $MYSQL_DATABASE;

-- Create user
CREATE USER IF NOT EXISTS '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';

-- Grant privileges
GRANT ALL PRIVILEGES ON $MYSQL_DATABASE.* TO '$MYSQL_USER'@'%';

-- Flush privileges
FLUSH PRIVILEGES;
EOF
    
    # Run the initialization SQL
    mysql --socket=/run/mysqld/mysqld.sock -u root < /tmp/init.sql
    
    echo "Initialization SQL completed."
    
    # Stop temporary MariaDB
    mysqladmin --socket=/run/mysqld/mysqld.sock shutdown
    wait $mysql_pid
    
    echo "Database initialization completed!"
else
    echo "Database already initialized."
fi

# Start MariaDB normally
echo "Starting MariaDB server..."
exec mysqld_safe --user=mysql
