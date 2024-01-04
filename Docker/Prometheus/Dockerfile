FROM ubuntu:22.04

ARG VERSION_PROMETHEUS=2.47.0
ARG CPU_ARCH=amd64

ARG DOOWNLOAD_URL=https://github.com/prometheus/prometheus/releases/download/v${VERSION_PROMETHEUS}/prometheus-${VERSION_PROMETHEUS}.linux-${CPU_ARCH}.tar.gz

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
    groupadd --system prometheus; \
    useradd -s /sbin/nologin --system -g prometheus prometheus; \
    mkdir -p /etc/prometheus; \
    mkdir -p /var/lib/prometheus

WORKDIR /tmp
RUN wget ${DOOWNLOAD_URL} || true
# if the vendor sets a geo block for downloading, then copy file from the local machine 
COPY prometheus-${VERSION_PROMETHEUS}.linux-${CPU_ARCH}.tar.gz* .

RUN \
    set -eux; \
    tar xzvf prometheus-${VERSION_PROMETHEUS}.linux-amd64.tar.gz; \
    cd prometheus-${VERSION_PROMETHEUS}.linux-amd64; \
    mv prometheus /usr/local/bin; \
    mv promtool /usr/local/bin; \
    chown prometheus:prometheus /usr/local/bin/prometheus; \
    chown prometheus:prometheus /usr/local/bin/promtool; \
    mv consoles /etc/prometheus; \
    mv console_libraries /etc/prometheus; \
    mv prometheus.yml /etc/prometheus; \
    chown -R prometheus:prometheus /etc/prometheus; \
    chown -R prometheus:prometheus /var/lib/prometheus

USER prometheus
WORKDIR /var/lib/prometheus

EXPOSE 9090

ENTRYPOINT [ "/usr/local/bin/prometheus" ]
CMD [ \
        "--config.file=/etc/prometheus/prometheus.yml", \
        "--storage.tsdb.path=/var/lib/prometheus/", \
        "--web.console.templates=/etc/prometheus/consoles", \
        "--web.console.libraries=/etc/prometheus/console_libraries" \
    ]
