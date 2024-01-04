FROM ubuntu:22.04

ARG VERSION_EXPORTER=1.6.1
ARG CPU_ARCH=amd64

ARG DOOWNLOAD_URL=https://github.com/prometheus/node_exporter/releases/download/v${VERSION_EXPORTER}/node_exporter-${VERSION_EXPORTER}.linux-${CPU_ARCH}.tar.gz

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
    groupadd --system node_exporter; \
    useradd -s /sbin/nologin --system -g node_exporter node_exporter

WORKDIR /tmp
RUN wget ${DOOWNLOAD_URL} || true
# if the vendor sets a geo block for downloading, then copy file from the local machine 
COPY node_exporter-${VERSION_EXPORTER}.linux-${CPU_ARCH}.tar.gz* .

RUN \
    set -eux; \
    tar xzvf node_exporter-${VERSION_EXPORTER}.linux-amd64.tar.gz; \
    cd node_exporter-${VERSION_EXPORTER}.linux-amd64; \
    mv node_exporter /usr/local/bin; \
    chown node_exporter:node_exporter /usr/local/bin/node_exporter; \
    mkdir -p /host; \
    chown -R node_exporter:node_exporter /host

USER node_exporter
WORKDIR /opt/host

EXPOSE 9100
ENTRYPOINT [ "/usr/local/bin/node_exporter" ]
