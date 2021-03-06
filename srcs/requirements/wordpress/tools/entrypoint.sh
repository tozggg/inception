#!/bin/sh

if [ ! -e /var/www/wordpress/wp-config.php ]; then
	mkdir -p /var/www/wordpress
	wp core download --allow-root --version=5.8.1 --path='/var/www/wordpress'
	chown -R www-data:www-data /var/www/wordpress

	wp config create	--allow-root --dbname=$DB_NAME --dbuser=$DB_USER\
						--dbpass=$DB_PASSWORD --dbhost=mariadb:3306 --path='/var/www/wordpress'

	wp core install     --allow-root --url=$DOMAIN_NAME --title=$WP_TITLE --path='/var/www/wordpress'\
						--admin_user=$WP_USER1_NAME --admin_password=$WP_USER1_PASSWORD --admin_email=$WP_USER1_EMAIL 

	wp user create      --allow-root $WP_USER2_NAME $WP_USER2_EMAIL --user_pass=$WP_USER2_PASSWORD\
						--role=author --path='/var/www/wordpress'
fi

mkdir -p /run/php
php-fpm7.3 --nodaemonize
