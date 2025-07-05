FROM debian:latest

RUN apt update && apt upgrade && apt install -y \
	php-fpm

COPY www.conf /etc/php/8.2/fpm/pool.d/.
# copy the www.conf file to the php-fpm pool.d directory

CMD ["php-fpm8.2", "-F"]

