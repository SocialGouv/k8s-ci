#!/bin/sh
set -e

export JOB_ID=${JOB_ID:-"$(uuidgen)"}
export K8SCI_BRANCH=${K8SCI_BRANCH:-"$(echo $K8SCI_REF | cut -d / -f3-)"}

cat $(dirname $0)/push-job.yaml | gomplate | kubectl \
    --server=$K8SCI_K8S_SERVER --token=$K8SCI_K8S_TOKEN \
    --namespace=$K8SCI_K8S_NS \
    create -f -
