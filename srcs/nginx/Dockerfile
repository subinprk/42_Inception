FROM debian:bullseye

RUN apt update && apt upgrade -y && apt install -y \
	nginx \
	openssl \
	&& apt clean \
	&& rm -rf /var/lib/apt/lists/*

# Generate self-signed SSL certificate
RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/nginx.key \
    -out /etc/nginx/ssl/nginx.crt \
    -subj "/C=US/ST=State/L=City/O=Organization/OU=OrgUnit/CN=localhost"

COPY default /etc/nginx/sites-available/default

CMD ["nginx", "-g", "daemon off;"]