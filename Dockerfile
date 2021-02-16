ARG GOMPLATE_VERSION=v3.6.0-slim
ARG ALPINE_VERSION=3.13

FROM hairyhenderson/gomplate:$GOMPLATE_VERSION as gomplate

# build webhook
FROM golang:alpine$ALPINE_VERSION AS build
ARG WEBHOOK_VERSION=2.8.0
WORKDIR /go/src/github.com/adnanh/webhook
RUN apk add --update -t build-deps curl libc-dev gcc libgcc
RUN curl -L --silent -o webhook.tar.gz https://github.com/adnanh/webhook/archive/${WEBHOOK_VERSION}.tar.gz && \
  tar -xzf webhook.tar.gz --strip 1 &&  \
  go get -d && \
  go build -o /usr/local/bin/webhook && \
  apk del --purge build-deps && \
  rm -rf /var/cache/apk/* && \
  rm -rf /go

FROM alpine:$ALPINE_VERSION
COPY --from=build /usr/local/bin/webhook /usr/local/bin/webhook
WORKDIR /etc/webhook
EXPOSE 9000
CMD ["/usr/local/bin/webhook"]

ARG KUBECTL_VERSION=1.20.1

COPY --from=gomplate /gomplate /usr/local/bin/gomplate

RUN apk add --update --no-cache \
  curl \
  util-linux \
  sed \
  jq \
  bash=~5 \
  coreutils=~8 \
  gettext=~0 \
  ca-certificates

RUN set -ex \
  && wget -O /dev/shm/kubectl \
    "https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
  && chmod +x /dev/shm/kubectl \
  && mv /dev/shm/kubectl /usr/local/bin/kubectl

COPY /opt /opt