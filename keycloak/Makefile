VERSION = v1.0
REPO    = tjpalanca/apps:keycloak

docker-pull-latest:
	docker pull $(REPO)-latest

docker-build:
	docker build --cache-from=$(REPO)-latest -t $(REPO)-$(VERSION) .

docker-build-dev:
	docker build -t $(REPO)-$(VERSION) .

docker-push:
	docker push $(REPO)-$(VERSION)

docker-bash:
	docker run -it --rm $(REPO)-$(VERSION) bash

docker-push-latest:
	docker tag $(REPO)-$(VERSION) $(REPO)-latest && \
	docker push $(REPO)-latest
