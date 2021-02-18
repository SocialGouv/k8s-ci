#!/bin/sh

REGISTRY_NS="registry"
K8S_JOBS_NS="k8s-jobs"
CREDS_SECRET_NAME="registry-creds"

REGISTRY_USER=$(kubectl -n $K8S_JOBS_NS get secret $CREDS_SECRET_NAME -ojsonpath='{.data.user}' 2>/dev/null | base64 --decode)
REGISTRY_PASS=$(kubectl -n $K8S_JOBS_NS get secret $CREDS_SECRET_NAME -ojsonpath='{.data.pass}' 2>/dev/null | base64 --decode)
if [ -z "$REGISTRY_PASS" ]; then
  REGISTRY_USER=k8s
  REGISTRY_PASS=$(openssl rand -base64 32)
  kubectl -n $K8S_JOBS_NS create secret generic $CREDS_SECRET_NAME \
    --from-literal=user=$REGISTRY_USER --from-literal=pass=$REGISTRY_PASS
fi

HTPASSWD=$(htpasswd -Bbn $REGISTRY_USER $REGISTRY_PASS)

kubectl label namespace $REGISTRY_NS cert=wildcard

helm -n $REGISTRY_NS upgrade --install docker-registry stable/docker-registry \
  --set persistence.enabled=true \
  --set persistence.size=100Gi \
  --set ingress.enabled=true \
  --set ingress.hosts[0]=${REGISTRY_HOST} \
  --set ingress.tls[0].hosts[0]=${REGISTRY_HOST} \
  --set ingress.tls[0].secretName=wildcard-crt \
  --set secrets.htpasswd=$HTPASSWD


# https://stackoverflow.com/a/61078171/5338073
kubectl -n $REGISTRY_NS annotate --overwrite ingress docker-registry 'nginx.ingress.kubernetes.io/proxy-body-size="0"'