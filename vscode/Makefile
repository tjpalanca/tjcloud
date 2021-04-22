VERSION = v2.0
APP     = vscode
REPO    = tjpalanca/apps:$(APP)

docker-build:
	docker build . --rm -t $(REPO)-$(VERSION)

docker-push:
	docker push $(REPO)-$(VERSION)

docker-tag-latest:
	docker tag $(REPO)-$(VERSION) $(REPO)-latest

docker-push-latest:
	make docker-tag-latest && \
	docker push $(REPO)-latest

docker-bash:
	docker run -it --rm --name $(APP) --entrypoint /bin/bash $(REPO)-$(VERSION)

docker-run:
	docker run -it --rm --name $(APP) \
	--env USER=tjpalanca \
	$(REPO)-$(VERSION)
