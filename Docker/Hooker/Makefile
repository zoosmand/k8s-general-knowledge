
REGISTRY := reg.docker.askug.net:5000
SERVICE := hooker
PROJECT := sb-11
VERSION := 0.0.4

all: build push

build:
	@ docker buildx build --no-cache --no-cache -t ${REGISTRY}/${SERVICE}-${PROJECT}:${VERSION} . > .log 2>&1

push:
	docker push ${REGISTRY}/${SERVICE}-${PROJECT}:${VERSION}
