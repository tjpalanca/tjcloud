VERSION = v1.0
REPO    = docker.pkg.github.com/tjpalanca/tjcloud/jupyter

docker-build:
	docker build . --rm -t $(REPO):$(VERSION)

docker-push:
	docker push $(REPO):$(VERSION)

docker-push-latest:
	docker tag $(REPO):$(VERSION) $(REPO):latest && \
	docker push $(REPO):latest

docker-build-gateway:
	docker build . --rm \
		--build-arg NB_UID="1000" \
		--build-arg NB_GID="1000" \
		--build-arg NB_USER="tjpalanca" \
		-t $(REPO)-gateway:$(VERSION) \
		-f Dockerfile.gateway

docker-push-gateway:
	docker push $(REPO)-gateway:$(VERSION)

docker-push-latest-gateway:
	docker tag $(REPO)-gateway:$(VERSION) $(REPO)-gateway:latest && \
	docker push $(REPO)-gateway:latest
