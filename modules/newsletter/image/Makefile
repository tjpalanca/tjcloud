VERSION = v1.0
REPO    = ghcr.io/tjpalanca/tjcloud/newsletter

docker-pull-latest:
	-docker pull $(REPO):latest

docker-build:
	docker buildx build \
		--build-arg BUILDKIT_INLINE_CACHE=1 \
		--cache-from=type=registry,ref=$(REPO) \
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
