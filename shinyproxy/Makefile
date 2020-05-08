# Application Information
APP_REPO=tjpalanca/apps
APP_NAME=shinyproxy
APP_VERS=1.0.0
APP_PORT=3838

# Calculated
NODENAME = $(shell kubectl get pod $(HOSTNAME) -o=jsonpath={'.spec.nodeName'})
REPO_VER=$(APP_REPO):$(APP_NAME)-$(APP_VERS)
REPO_LAT=$(APP_REPO):$(APP_NAME)-latest
SHELL:=/bin/bash

# Pull docker image
docker-pull:
	-docker pull $(REPO_LAT)

# Builds the docker image for this particular version
docker-build:
	docker build \
		--cache-from=$(REPO_VER) \
		--cache-from=$(REPO_LAT) \
		-t $(REPO_VER) .

# Publishes the built docker image to Docker Hub
docker-publish:
	docker tag $(REPO_VER) $(REPO_LAT) && \
	docker push $(REPO_LAT) && \
	docker push $(REPO_VER)

# Development ENV
TEST_ENV = \
	-e SHINYPROXY_EMAIL_APP_USERNAME="dummy" -e SHINYPROXY_EMAIL_APP_PASSWORD="dummy" \
	-e CLOUD66_STACK_NAMESPACE="dummy" \
	-e TJTOOLS_PASSWORD="dummy" \
	-e SOCIAL_GOOGLE_ID="dummy" -e SOCIAL_GOOGLE_SECRET="dummy" \
	-e SOCIAL_TWITTER_ID="dummy" -e SOCIAL_TWITTER_SECRET="dummy"

# Shell into the container
docker-shell:
	docker run -it --name $(APP_NAME) --rm $(TEST_ENV) $(REPO_VER) bash

# Test if the container runs
docker-test:
	docker run -it --name $(APP_NAME) -d $(TEST_ENV) $(REPO_VER) && \
	echo "Waiting 15 seconds for app startup" && sleep 15 && \
	echo "Docker Logs ==========" && docker logs $(APP_NAME) && \
	echo "======================" && \
	if [ "$$(docker inspect -f {{.State.Running}} $(APP_NAME))" == "false" ]; \
	then 	echo "Container failed"; \
			docker stop $(APP_NAME) | xargs docker rm; exit 1; \
	else 	echo "Container succeeded"; \
			docker stop $(APP_NAME) | xargs docker rm; exit 0; \
	fi
