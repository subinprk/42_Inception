FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
	php-fpm \
	php-mysqli \
	# php-curl \
	curl \
	mariadb-client \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

# Create the directory for PHP-FPM PID file
RUN mkdir -p /run/php

COPY www.conf /etc/php/7.4/fpm/pool.d/.
COPY script.sh .
RUN chmod +x script.sh

CMD ["./script.sh"]