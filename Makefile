IMAGE_NAME = quay.io/xtecuan/s2i-payara5-server-full-jdk17

.PHONY: build
build:
	docker build -t $(IMAGE_NAME) .

.PHONY: push
push:
	docker push $(IMAGE_NAME):latest

.PHONY: test
test:
	docker build -t $(IMAGE_NAME)-candidate .
	IMAGE_NAME=$(IMAGE_NAME)-candidate test/run
