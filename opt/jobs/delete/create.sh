#!/bin/sh
set -e

export JOB_ID=${JOB_ID:-"$(uuidgen)"}
export K8SCI_BRANCH=${K8SCI_BRANCH:-"$(echo $K8SCI_REF | cut -d / -f3-)"}

cat $(dirname $0)/delete-job.yaml | gomplate | kubectl -n $K8SCI_K8S_NS create -f -
