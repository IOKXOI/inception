all: 
	mkdir -p /home/sydauria/data
	mkdir -p /home/sydauria/data/mariadb
	mkdir -p /home/sydauria/data/wordpress
	docker compose -f ./srcs/docker-compose.yml up -d --build

down:
	docker compose -f ./srcs/docker-compose.yml down

stop:
	docker compose -f ./srcs/docker-compose.yml stop

start:
	docker compose -f ./srcs/docker-compose.yml restart

clean: down

fclean: clean
	docker volume rm srcs_mariadb_volume srcs_wordpress_volume
	sudo rm -rf /home/sydauria/data
	docker system prune -af

re: fclean all

logs:
	docker logs my_wordpress_container
	docker logs my_mariadb_container
	docker logs my_nginx_container
	
ls:
	docker image ls
	docker container ls
	docker volume ls
	docker network ls

.Phony: all down clean fclean re logs ls


## mysql connexion
# docker exec -it mariadb mysql -u root -p
# SHOW DATABASES;
# USE inceptions;
# SHOW TABLES;
# SELECT * FROM wp_users;