#!/bin/sh
set -e
cat $(dirname $0)/build-job.yaml | gomplate | kubectl \
  --server=$K8SCI_K8S_SERVER --token=$K8SCI_K8S_TOKEN \
  --namespace=$K8SCI_K8S_NS \
  create -f -
