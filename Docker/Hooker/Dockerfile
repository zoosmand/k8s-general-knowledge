FROM golang:alpine AS builder

ARG BUILD_DIR=/tmp/build

RUN mkdir -p ${BUILD_DIR}

WORKDIR ${BUILD_DIR}
COPY ./main.go .

RUN \
    apk add binutils

# Build and strip exporter
RUN \
    go mod init main; \
    go get; \
    CGO_ENABLED=0 GOOS=linux GOARCH=amd64 \
    go build -a -tags netgo -ldflags '-w -extldflags "-static"' -o /go/bin/scratch; \
    strip /go/bin/scratch

FROM scratch

WORKDIR /

COPY --from=0 /go/bin/scratch .

EXPOSE 18080

ENTRYPOINT [ "./scratch" ]
