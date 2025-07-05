From debian:latest

RUN apt update && apt upgrade && apt install -y \
	nginx

COPY default /etc/nginx/sites-available/.
# copy the default configuration file to the sites-available directory

CMD ["nginx", "-g", "daemon off;"]
