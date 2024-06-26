NAME = inception
COMPOSE = ./srcs/docker-compose.yml

all: folders up 

folders:
	sudo mkdir -p /home/csilva-f/data
	sudo mkdir -p /home/csilva-f/data/mdbfiles
	sudo mkdir -p /home/csilva-f/data/wpfiles

up:
	docker compose -p $(NAME) -f $(COMPOSE) up --build -d

down:
	docker compose -p $(NAME) -f $(COMPOSE) down --volumes

start:
	docker compose -p $(NAME) start

stop:
	docker compose -p $(NAME) -f $(COMPOSE) stop

rm-image:
	docker rmi -f $$(docker images -q)

clean: down rm-image

fclean: clean
	@sudo rm -rf /home/csilva-f/data
	@docker system prune -a

re: fclean folders up
