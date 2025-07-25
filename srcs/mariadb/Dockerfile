FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
	mariadb-server \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

COPY ./50-server.cnf  /etc/mysql/mariadb.conf.d/.
COPY init.sql /etc/mysql/init.sql
COPY script.sh .

# Create necessary directories and set permissions
RUN mkdir -p /run/mysqld /var/lib/mysql
RUN chown -R mysql:mysql /var/lib/mysql /run/mysqld
RUN chmod +x script.sh

CMD ["./script.sh"]

