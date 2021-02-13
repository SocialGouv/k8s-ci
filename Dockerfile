ARG GOMPLATE_VERSION=v3.6.0-slim
ARG WEBHOOK_VERSION=2.8.0

FROM hairyhenderson/gomplate:$GOMPLATE_VERSION as gomplate
FROM almir/webhook:$WEBHOOK_VERSION

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