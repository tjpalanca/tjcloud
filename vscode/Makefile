VERSION = v1.0
APP     = vscode
REPO    = tjpalanca/apps:$(APP)

docker-build:
	docker build . --rm -t $(REPO)-$(VERSION)

docker-push:
	docker push $(REPO)-$(VERSION)

docker-push-latest:
	docker tag $(REPO)-$(VERSION) $(REPO)-latest && \
	docker push $(REPO)-latest

docker-bash:
	docker run -it --rm --name $(APP) --entrypoint /bin/bash $(REPO)-$(VERSION)