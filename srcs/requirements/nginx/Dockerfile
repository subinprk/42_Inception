FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y && apt-get install -y \
	nginx \
	openssl \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

# Generate SSL certificate
RUN mkdir -p /etc/nginx/ssl
RUN openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
	-keyout /etc/nginx/ssl/nginx.key \
	-out /etc/nginx/ssl/nginx.crt \
	-subj "/C=DE/ST=Berlin/L=Berlin/O=42School/OU=subpark/CN=localhost"

COPY default /etc/nginx/sites-available/.
# copy the default configuration file to the sites-available directory

COPY nginx.conf /etc/nginx/nginx.conf
# copy the nginx configuration file to the nginx directory

CMD ["nginx", "-g", "daemon off;"]
