FROM ubuntu:22.04

ARG VERSION_PUSHGATEWAY=1.6.2
ARG CPU_ARCH=amd64

ARG DOOWNLOAD_URL=https://github.com/prometheus/pushgateway/releases/download/v${VERSION_PUSHGATEWAY}/pushgateway-${VERSION_PUSHGATEWAY}.linux-${CPU_ARCH}.tar.gz

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
    groupadd --system pushgateway; \
    useradd -s /sbin/nologin --system -g pushgateway pushgateway; \
    mkdir -p /etc/pushgateway; \
    mkdir -p /var/lib/pushgateway

WORKDIR /tmp
RUN wget ${DOOWNLOAD_URL} || true
# if the vendor sets a geo block for downloading, then copy file from the local machine
COPY pushgateway-${VERSION_PUSHGATEWAY}.linux-${CPU_ARCH}.tar.gz* .

RUN \
    set -eux; \
    tar xzvf pushgateway-${VERSION_PUSHGATEWAY}.linux-amd64.tar.gz; \
    cd pushgateway-${VERSION_PUSHGATEWAY}.linux-amd64; \
    mv pushgateway /usr/local/bin; \
    chown pushgateway:pushgateway /usr/local/bin/pushgateway

USER pushgateway
WORKDIR /var/lib/pushgateway

EXPOSE 9091

ENTRYPOINT [ "/usr/local/bin/pushgateway" ]
CMD []

# HEALTHCHECK --interval=60s --timeout=10s --start-period=10s CMD (curl --fail http://localhost:9091/-/healthy) || exit 1

