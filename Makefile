# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: taejkim <taejkim@student.42.fr>            +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/06/13 18:13:32 by taejkim           #+#    #+#              #
#    Updated: 2022/06/14 15:18:39 by taejkim          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME = inception
YML = srcs/docker-compose.yml


all: $(NAME)

$(NAME):
	./srcs/requirements/tools/setup.sh
	docker-compose -f $(YML) up -d --build

stop:
	docker-compose -f $(YML) stop

clean: stop
	docker-compose -f $(YML) down

fclean: clean
	docker system prune -af
	sudo rm -rf /home/taejkim/data

re: fclean all

.PHONY: all stop clean fclean re
