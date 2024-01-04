FROM ubuntu:22.04

ARG VERSION_ALERTMANAGER=0.26.0
ARG CPU_ARCH=amd64

ARG DOOWNLOAD_URL=https://github.com/prometheus/alertmanager/releases/download/v${VERSION_ALERTMANAGER}/alertmanager-${VERSION_ALERTMANAGER}.linux-${CPU_ARCH}.tar.gz

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
    groupadd --system alertmanager; \
    useradd -s /sbin/nologin --system -g alertmanager alertmanager; \
    mkdir -p /etc/alertmanager; \
    mkdir -p /var/lib/alertmanager

WORKDIR /tmp
RUN wget ${DOOWNLOAD_URL} || true
# if the vendor sets a geo block for downloading, then copy file from the local machine 
COPY alertmanager-${VERSION_ALERTMANAGER}.linux-${CPU_ARCH}.tar.gz* .

RUN \
    set -eux; \
    tar xzvf alertmanager-${VERSION_ALERTMANAGER}.linux-${CPU_ARCH}.tar.gz; \
    cd alertmanager-${VERSION_ALERTMANAGER}.linux-${CPU_ARCH}; \
    mv alertmanager /usr/local/bin; \
    mv amtool /usr/local/bin; \
    chown alertmanager:alertmanager /usr/local/bin/alertmanager; \
    chown alertmanager:alertmanager /usr/local/bin/amtool; \
    mv alertmanager.yml /etc/alertmanager; \
    chown -R alertmanager:alertmanager /etc/alertmanager; \
    chown -R alertmanager:alertmanager /var/lib/alertmanager

USER alertmanager
WORKDIR /var/lib/alertmanager

EXPOSE 9093

ENTRYPOINT [ "/usr/local/bin/alertmanager" ]
CMD [ \
        "--config.file=/etc/alertmanager/alertmanager.yml" \
    ]


# HEALTHCHECK --interval=60s --timeout=10s --start-period=10s CMD (curl --fail http://localhost:9093/-/healthy) || exit 1
