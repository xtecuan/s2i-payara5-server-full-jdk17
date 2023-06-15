IMAGE_NAME = quay.factory.promnet.com.sv:5000/spi/s2i-payara5-server-full-jdk17

.PHONY: build
build:
	docker build -t $(IMAGE_NAME) .

.PHONY: test
test:
	docker build -t $(IMAGE_NAME)-candidate .
	IMAGE_NAME=$(IMAGE_NAME)-candidate test/run
