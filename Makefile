.PHONY: run stop setup

# Load environment variables from auth_server/.env file
include auth_server/.env
export $(shell sed 's/=.*//' auth_server/.env)

run:
	docker-compose --env-file auth_server/.env up -d flutter_app flask_app

stop:
	docker-compose down

setup:
	docker-compose --env-file auth_server/.env up -d db
	sleep 10 # Wait for the database to be ready
	@DB_CONTAINER_ID=$$(docker-compose ps -q db) && \
	echo "DB_CONTAINER_ID is $$DB_CONTAINER_ID" && \
	docker exec -i $$DB_CONTAINER_ID psql -U $(DB_USER) -d $(DB_NAME) -f /scripts/login.sql && \
	docker exec -i $$DB_CONTAINER_ID psql -U $(DB_USER) -d $(DB_NAME) -f /scripts/records.sql

clean:
	docker-compose down -v
