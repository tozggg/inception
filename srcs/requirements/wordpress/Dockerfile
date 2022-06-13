FROM		debian:buster

RUN			apt-get -y update
RUN			apt-get -y upgrade
RUN			apt-get -y install mariadb-client
RUN			apt-get -y install php7.3
RUN			apt-get -y install php-fpm
RUN			apt-get -y install php-mysqli
RUN			apt-get -y install curl
RUN			apt-get -y install wget

RUN			curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar &&\
			chmod +x wp-cli.phar &&\
			mv wp-cli.phar /usr/local/bin/wp

COPY		./conf/www.conf			/etc/php/7.3/fpm/pool.d

COPY		./tools/entrypoint.sh	/entrypoint.sh
RUN			chmod +x /entrypoint.sh
entrypoint	["/entrypoint.sh"]
