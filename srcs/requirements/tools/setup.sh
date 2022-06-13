#!/bin/bash

if [ ! -e "/home/taejkim/data" ]; then
	sudo mkdir -p /home/taejkim/data/db
	sudo mkdir -p /home/taejkim/data/wp
fi

if [ ! -e "./.hostset"]; then
	sudo chmod 777 /etc/hosts
	sudo echo "127.0.0.1 taejkim.42.fr" >> /etc/hosts
	touch .hostset
fi
