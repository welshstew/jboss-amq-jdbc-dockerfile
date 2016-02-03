
IMAGE_NAME = registry.access.redhat.com/jboss-amq-6/amq62-openshift

build:
	docker build -t $(IMAGE_NAME) .

.PHONY: test
test:
	docker build -t $(IMAGE_NAME)-candidate .
	IMAGE_NAME=$(IMAGE_NAME)-candidate test/run
