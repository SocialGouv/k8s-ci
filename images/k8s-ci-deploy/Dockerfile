ARG ALPINE_VERSION=3.13
FROM alpine:$ALPINE_VERSION

ARG KUBECTL_VERSION=1.20.1

ARG KUSTOMIZE_VERSION=3.5.2

ARG HELM_VERSION=3.4.2

RUN set -ex \
  #
  && apk add --update --no-cache \
    bash=~5 \
    coreutils=~8 \
    gettext=~0 \
    ca-certificates \
    jq \
    postgresql-client \
    curl \
    sed \
    grep \
  #
  && wget -O /dev/shm/kubectl \
    "https://storage.googleapis.com/kubernetes-release/release/v${KUBECTL_VERSION}/bin/linux/amd64/kubectl" \
  && chmod +x /dev/shm/kubectl \
  && mv /dev/shm/kubectl /usr/local/bin/kubectl \
  #
  && wget -O /dev/shm/kustomize.tar \
    "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_amd64.tar.gz" \
  && tar xvzf /dev/shm/kustomize.tar  \
  && mv /kustomize /usr/local/bin/kustomize \
  #
  && wget -O /dev/shm/helm.tar.gz \
    "https://get.helm.sh/helm-v${HELM_VERSION}-linux-amd64.tar.gz" \
  && tar xvzf /dev/shm/helm.tar.gz  \
  && mv /linux-amd64/helm /usr/local/bin/helm \
  ;

USER 1000
ENTRYPOINT [ "/bin/sh", "-c" ]
CMD []
