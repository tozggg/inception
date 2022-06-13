FROM		debian:buster

RUN			apt-get -y update
RUN			apt-get -y upgrade
RUN			apt-get -y install nginx
RUN			apt-get -y install openssl

RUN			openssl req -newkey rsa:4096 -x509 -days 365 -nodes\
			-subj "/C=KR/ST=Seoul/O=42/OU=gon/CN=taejkim.42.fr"\
			-out /etc/ssl/certs/$DOMAIN_NAME.crt &&\
			-keyout /etc/ssl/private/$DOMAIN_NAME.key\
			chmod 777 $DOMAIN_NAME.crt $DOMAIN_NAME.key

COPY		./conf/default	/etc/nginx/sites-available/default

ENTRYPOINT	["nginx", "-g", "daemon off;"]
