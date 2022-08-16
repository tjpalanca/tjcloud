VERSION = v1.3
REPO    = ghcr.io/tjpalanca/tjcloud/code

docker-pull-latest:
	-docker pull $(REPO):latest

docker-build:
	cd ../ && \
	docker buildx build \
		--build-arg BUILDKIT_INLINE_CACHE=1 \
		--cache-from=type=registry,ref=$(REPO) \
		-f code/Dockerfile \
		-t $(REPO):$(VERSION) .

docker-push:
	docker push $(REPO):$(VERSION)

docker-bash:
	docker run -it --rm --entrypoint /bin/bash $(REPO):$(VERSION)

docker-push-latest:
	docker tag $(REPO):$(VERSION) $(REPO):latest && \
	docker push $(REPO):latest

docker-publish:
	make docker-push && \
	make docker-push-latest

setup:
	kubectl apply -f permissions.yml
