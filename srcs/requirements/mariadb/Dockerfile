FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y && apt-get install -y\
	mariadb-server \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

COPY ./50-server.cnf  /etc/mysql/mariadb.conf.d/.
COPY init.sql /etc/mysql/init.sql
COPY init-mariadb.sh /usr/local/bin/init-mariadb.sh

RUN mkdir /run/mysqld
RUN chmod +x /usr/local/bin/init-mariadb.sh
RUN chown -R mysql:mysql /var/lib/mysql /run/mysqld

CMD ["/usr/local/bin/init-mariadb.sh"]