
REGISTRY := reg.docker.askug.net:5000
SERVICE := prometheus
PROJECT := sb-11
VERSION := 0.0.0

all: build push

build:
	@ docker buildx build --no-cache -t ${REGISTRY}/${SERVICE}-${PROJECT}:${VERSION} . > .log 2>&1

push:
	docker push ${REGISTRY}/${SERVICE}-${PROJECT}:${VERSION}
