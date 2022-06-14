FROM		debian:buster

RUN			apt-get -y update
RUN			apt-get -y upgrade
RUN			apt-get -y install nginx
RUN			apt-get -y install openssl

RUN			openssl req -newkey rsa:4096 -x509 -days 365 -nodes\
			-subj "/C=KR/ST=Seoul/O=42/OU=gon/CN=taejkim.42.fr"\
			-out /etc/ssl/certs/taejim.42.fr\
			-keyout /etc/ssl/private/taejim.42.fr.key
RUN			chmod 777 /etc/ssl/certs/taejim.42.fr.crt
RUN			chmod 777 /etc/ssl/private/taejim.42.fr.key

COPY		./conf/default	/etc/nginx/sites-available/default

ENTRYPOINT	["nginx", "-g", "daemon off;"]
