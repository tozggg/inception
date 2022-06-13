#!/bin/bash

if [ ! -e /var/www/wordpress/wp-config.php ]; then
	wget https://wordpress.org/wordpress-5.9.1.tar.gz -P /var/www
	tar -xvf /var/www/wordpress-5.9.1.tar.gz
	rm /var/www/wordpress-5.9.1.tar.gz

	chown -R www-data:www-data /var/www/wordpress

	wp config create	--allow-root --dbname=$DB_NAME --dbuser=$DB_USER\
						--dbpass=$DB_PASSWORD --dbhost=mariadb:3306 --path='/var/www/wordpress'
	
	wp core install     --allow-root --url=$DOMAIN_NAME --title=$WP_TITLE --admin_user=$WP_USER1_NAME\
                        --admin_password=$WP_USER1_PASSWORD --admin_email=$WP_USER1_EMAIL --path='/var/www/wordpress'
    
	wp user create      --allow-root $WP_USER2_NAME $WP_USER2_EMAIL --user_pass=$WP_USER2_PASSWORD --role=author\
                        --path='/var/www/wordpress'
fi

mkdir -p /run/php
php-fpm7.3 --nodaemonize
