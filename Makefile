NAME = inception
COMPOSE = ./srcs/docker-compose.yml
DIR_PATH ?= /home/csilva-f/data


all: dir up 

# Create necessary directories for MariaDB and WordPress data
dir:
	sudo mkdir -p $(DIR_PATH)
	sudo mkdir -p $(DIR_PATH)/database
	sudo mkdir -p $(DIR_PATH)/wpfiles

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

re: fclean dir up
