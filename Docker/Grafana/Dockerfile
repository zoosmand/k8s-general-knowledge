FROM ubuntu:22.04

ARG VERSION_GRAFANA=10.1.1
ARG CPU_ARCH=amd64

ARG DOOWNLOAD_URL=https://dl.grafana.com/enterprise/release/grafana-enterprise-${VERSION_GRAFANA}.linux-${CPU_ARCH}.tar.gz
ARG GF_PATHS_CONFIG=/opt/grafana/conf/defaults.ini

RUN \
    set -eux; \
    apt-get update -y; \
    apt-get install -y --no-install-recommends \
        wget \
        ca-certificates \
        ; \
    apt-get clean; \
    apt-get -yf autoremove; \
    rm -rf /var/lib/apt/lists/*

RUN \
    set -eux; \
    groupadd --system grafana; \
    useradd -s /sbin/nologin --system -g grafana grafana; \
    mkdir -p /opt/grafana

WORKDIR /tmp
RUN wget ${DOOWNLOAD_URL} || true
# if a geo block exists, copy file from local fs 
COPY grafana-enterprise-${VERSION_GRAFANA}.linux-amd64.tar.gz* .

RUN \
    tar xzvf grafana-enterprise-${VERSION_GRAFANA}.linux-amd64.tar.gz; \
    mv ./grafana-${VERSION_GRAFANA}/* /opt/grafana/; \ 
    chown -R grafana:grafana /opt/grafana

USER grafana
WORKDIR /opt/grafana

ENV GF_PATHS_CONFIG ${GF_PATHS_CONFIG}

EXPOSE 3000
CMD [  "/bin/sh", "-c", "(/opt/grafana/bin/grafana server --config $GF_PATHS_CONFIG)" ]

#HEALTHCHECK --interval=60s --timeout=10s --start-period=10s CMD (curl --fail http://localhost:3000/healthz) || exit 1
#HEALTHCHECK --interval=60s --timeout=10s --start-period=10s CMD (curl --fail http://localhost:3000/api/health) || exit 1
