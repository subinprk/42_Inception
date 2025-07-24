FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
	php-fpm \
	php-mysqli \
	curl \
	mariadb-client \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

COPY www.conf /etc/php/7.4/fpm/pool.d/.
# copy the www.conf file to the php-fpm pool.d directory

# Create the PHP-FPM run directory
RUN mkdir -p /run/php

COPY script.sh .
RUN chmod +x script.sh

CMD ["./script.sh"]

