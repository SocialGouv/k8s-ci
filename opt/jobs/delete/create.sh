#!/bin/sh
set -e

export K8SCI_GID=${K8SCI_GID:-"$(date +'%s%3N')"}
export K8SCI_BRANCH=${K8SCI_BRANCH:-"$(echo $K8SCI_REF | cut -d / -f3-)"}

cat $(dirname $0)/delete-job.yaml | gomplate | kubectl -n $K8SCI_K8S_NS create -f -
