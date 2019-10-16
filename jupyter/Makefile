VERSION = v1.0
REPO    = docker.pkg.github.com/tjpalanca/tjcloud/jupyter

docker-build:
	docker build . --rm -t $(REPO):$(VERSION)

docker-push-workaround:
	sudo systemctl stop docker && \
	echo '{ "max-concurrent-uploads": 1 }' > /etc/docker/daemon.json && \
	sudo systemctl start docker

docker-push:
	docker push $(REPO):$(VERSION)

docker-push-latest:
	docker tag $(REPO):$(VERSION) $(REPO):latest && \
	docker push $(REPO):latest

docker-build-gateway:
	docker build . --rm \
		-t $(REPO)-gateway:$(VERSION) \
		-f Dockerfile.gateway

docker-push-gateway:
	docker push $(REPO)-gateway:$(VERSION)

docker-push-latest-gateway:
	docker tag $(REPO)-gateway:$(VERSION) $(REPO)-gateway:latest && \
	docker push $(REPO)-gateway:latest
