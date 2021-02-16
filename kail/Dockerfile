ARG KAIL_VERSION=0.15.0
ARG ALPINE_VERSION=3

FROM abozanich/kail:v$KAIL_VERSION as kail

FROM alpine:$ALPINE_VERSION

ARG KUBECTL_VERSION=1.20.1

COPY --from=kail /kail /usr/local/bin/kail

RUN set -ex \
  #
  && apk add --update --no-cache \
    bash=~5 \
    coreutils=~8 \
    gettext=~0 \
    ca-certificates \
    jq \
  #
  && wget -O /dev/shm/kubectl \
    "https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
  && chmod +x /dev/shm/kubectl \
  && mv /dev/shm/kubectl /usr/local/bin/kubectl \
  ;

USER 1000
ENTRYPOINT [ "/bin/sh", "-c" ]
CMD []
