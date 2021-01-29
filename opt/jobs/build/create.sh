#!/bin/sh
set -e

. /opt/env.sh

cat $(dirname $0)/build-job.yaml | gomplate | kubectl \
  --server=$K8S_SERVER --token=$K8S_TOKEN \
  --namespace=$K8S_NS \
  create -f -
