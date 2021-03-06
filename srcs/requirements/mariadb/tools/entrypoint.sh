#!/bin/sh

if [ ! -d /var/lib/mysql/$DB_NAME ]; then
	service mysql start
	
	mysql -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
	mysql -e "CREATE USER '$DB_USER'@'%' IDENTIFIED BY '$DB_PASSWORD';"
	mysql -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%';"
	mysql -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '$DB_PASSWORD';"
	mysql -e "FLUSH PRIVILEGES;"
	
	service mysql stop
fi

mysqld_safe
