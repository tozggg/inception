FROM		debian:buster

RUN			apt-get -y update
RUN			apt-get -y upgrade
RUN			apt-get -y install mariadb-server

COPY		./conf/50-server.cnf	/etc/mysql/mariadb.conf.d

COPY		./tools/entrypoint.sh	/entrypoint.sh
RUN			chmod +x /entrypoint.sh
ENTRYPOINT	["/entrypoint.sh"]
