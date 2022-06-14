# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: taejkim <taejkim@student.42.fr>            +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/06/13 18:13:32 by taejkim           #+#    #+#              #
#    Updated: 2022/06/14 14:28:47 by taejkim          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME = inception
YML = srcs/docker-compose.yml


all: $(NAME)

$(NAME):
	sudo ./srcs/requirements/tools/setup.sh
	sudo docker-compose -f $(YML) up -d --build

stop:
	sudo docker-compose -f $(YML) stop

clean: stop
	sudo docker-compose -f $(YML) down

fclean: clean
	sudo docker system prune -af
	sudo rm -rf /home/taejkim/data

re: fclean all

.PHONY: all stop clean fclean re
