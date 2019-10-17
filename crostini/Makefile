compose-build:
	docker-compose build

compose-up:
	docker-compose up --detach

compose-stop:
	docker-compose stop

compose-down:
	docker-compose down

compose-push:
	docker-compose push

compose-pull:
	docker-compose pull

setup-crostini:
	bash install-docker.sh && \
	make compose-pull && \
	make compose-up && \
	bash setup-env.sh

