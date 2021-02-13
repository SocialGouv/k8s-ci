#!/bin/bash
set -e

# required vars
declare -a required_vars=(
  K8SCI_K8S_DEPLOY_SERVER \
  K8SCI_K8S_DEPLOY_NS \
  K8SCI_HELM_CHART \
  K8SCI_HELM_RELEASE \
  K8SCI_IMAGE_TAG \
)
for var_name in "${required_vars[@]}"
do
  if [ -z "$(eval "echo \$$var_name")" ]; then
    echo "Missing environment variable $var_name"
    exit 1
  fi
done


export K8SCI_K8S_TOKEN_SECRET_NAME=${K8SCI_K8S_TOKEN_SECRET_NAME:-"k8s"}
export K8SCI_K8S_TOKEN_SECRET_KEY=${K8SCI_K8S_TOKEN_SECRET_KEY:-"token"}
export K8SCI_HELM_ARGS=${K8SCI_HELM_ARGS:-""}

cat $(dirname $0)/deploy-job.yaml | gomplate | kubectl \
  --server=$K8SCI_K8S_SERVER --token=$K8SCI_K8S_TOKEN \
  --namespace=$K8SCI_K8S_NS \
  create -f -
