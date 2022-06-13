# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: taejkim <taejkim@student.42.fr>            +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/06/13 18:13:32 by taejkim           #+#    #+#              #
#    Updated: 2022/06/13 19:52:27 by taejkim          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME = inception
YML = ./srcs/docker-compose.yml


all: $(NAME)

$(NAME):
	sudo ./srcs/requirements/tools/setup.sh
	sudo docker-compose -f $(YML) up -d --bulid

stop:
	sudo docker-compose -f $(YML) stop

clean: stop
	sudo docker-compose -f $(YML) down

fclean: clean
	sudo docker system prune -af
	sudo rm -rf /home/taejkim/data

re: fclean all

.PHONY: all stop clean fclean re
