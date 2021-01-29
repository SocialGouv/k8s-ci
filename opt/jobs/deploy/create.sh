#!/bin/sh
set -e

. /opt/env.sh

if [ -z "$K8S_DEPLOY_SERVER" ]; then
  echo "missing K8S_DEPLOY_SERVER env var, export from env.hook.sh at webhook install"
  exit 1
fi

cat $(dirname $0)/deploy-job.yaml | gomplate | kubectl \
    --server=$K8S_SERVER --token=$K8S_TOKEN \
    --namespace=$K8S_NS \
    create -f -
