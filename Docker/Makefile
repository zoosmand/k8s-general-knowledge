
REGISTRY := reg.docker.askug.net:5000
PROJECT := sb-11
VERSION := 0.0.5

all: 
	@ echo "It's working"

build: \
	build_prometheus \
	build_nodeexporter \
	build_pushgateway \
	build_pushgatewatest \
	build_alertmanager \
	build_grafana \
	build_hooker

push: \
	push_prometheus \
	push_nodeexporter \
	push_pushgateway \
	push_pushgatewatest \
	push_alertmanager \
	push_grafana \
	push_hooker

# ---
build_prometheus:
	${MAKE} build -C ./Prometheus REGISTRY=${REGISTRY} PROJECT=${PROJECT} VERSION=${VERSION}

build_nodeexporter:
	${MAKE} build -C ./NodeExporter REGISTRY=${REGISTRY} PROJECT=${PROJECT} VERSION=${VERSION}

build_pushgateway:
	${MAKE} build -C ./Pushgateway REGISTRY=${REGISTRY} PROJECT=${PROJECT} VERSION=${VERSION}

build_pushgatewatest:
	${MAKE} build -C ./PushgatewayTest REGISTRY=${REGISTRY} PROJECT=${PROJECT} VERSION=${VERSION}

build_alertmanager:
	${MAKE} build -C ./Alertmanager REGISTRY=${REGISTRY} PROJECT=${PROJECT} VERSION=${VERSION}

build_grafana:
	${MAKE} build -C ./Grafana REGISTRY=${REGISTRY} PROJECT=${PROJECT} VERSION=${VERSION}

build_hooker:
	${MAKE} build -C ./Hooker REGISTRY=${REGISTRY} PROJECT=${PROJECT} VERSION=${VERSION}

# ---
push_prometheus:
	${MAKE} push -C ./Prometheus REGISTRY=${REGISTRY} PROJECT=${PROJECT} VERSION=${VERSION}

push_nodeexporter:
	${MAKE} push -C ./NodeExporter REGISTRY=${REGISTRY} PROJECT=${PROJECT} VERSION=${VERSION}

push_pushgateway:
	${MAKE} push -C ./Pushgateway REGISTRY=${REGISTRY} PROJECT=${PROJECT} VERSION=${VERSION}

push_pushgatewatest:
	${MAKE} push -C ./PushgatewayTest REGISTRY=${REGISTRY} PROJECT=${PROJECT} VERSION=${VERSION}

push_alertmanager:
	${MAKE} push -C ./Alertmanager REGISTRY=${REGISTRY} PROJECT=${PROJECT} VERSION=${VERSION}

push_grafana:
	${MAKE} push -C ./Grafana REGISTRY=${REGISTRY} PROJECT=${PROJECT} VERSION=${VERSION}

push_hooker:
	${MAKE} push -C ./Hooker REGISTRY=${REGISTRY} PROJECT=${PROJECT} VERSION=${VERSION}
