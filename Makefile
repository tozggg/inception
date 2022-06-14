# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    Makefile                                           :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: taejkim <taejkim@student.42.fr>            +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2022/06/13 18:13:32 by taejkim           #+#    #+#              #
#    Updated: 2022/06/14 19:57:22 by taejkim          ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

NAME = inception
YML = srcs/docker-compose.yml


all: $(NAME)

$(NAME):
	./srcs/requirements/tools/setup.sh
	sudo docker-compose -f $(YML) up -d --build

clean:
	sudo docker-compose -f $(YML) down

fclean: clean
	sudo docker system prune -af
	sudo docker volume rm $$(sudo docker volume ls -q)
	sudo rm -rf /home/taejkim/data

re: fclean all

.PHONY: all clean fclean re
