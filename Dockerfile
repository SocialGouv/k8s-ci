ARG GOMPLATE_VERSION=v3.6.0-slim
ARG WEBHOOK_VERSION=2.8.0

FROM hairyhenderson/gomplate:$GOMPLATE_VERSION as gomplate
FROM almir/webhook:$WEBHOOK_VERSION

ARG KUBECTL_VERSION=1.20.1

COPY --from=gomplate /gomplate /usr/local/bin/gomplate

# envsubst
ENV BUILD_DEPS="gettext"  \
    RUNTIME_DEPS="libintl"
RUN set -x && \
    apk add --update $RUNTIME_DEPS && \
    apk add --virtual build_deps $BUILD_DEPS &&  \
    cp /usr/bin/envsubst /usr/local/bin/envsubst && \
    apk del build_deps

# kubectl
RUN set -ex \
  #
  && apk add --update --no-cache \
    bash=~5 \
    coreutils=~8 \
    gettext=~0 \
    ca-certificates \
  #
  && wget -O /dev/shm/kubectl \
    "https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
  && chmod +x /dev/shm/kubectl \
  && mv /dev/shm/kubectl /usr/local/bin/kubectl

# curl
RUN apk add --no-cache curl

# uuidgen
RUN apk add --no-cache util-linux

# sed
RUN apk add --no-cache sed

# jq
RUN apk add --no-cache jq

COPY /bin /usr/local/bin
COPY /opt /opt