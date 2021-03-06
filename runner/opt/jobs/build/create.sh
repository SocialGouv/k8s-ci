#!/bin/bash
set -e

# required vars
declare -a required_vars=(
  K8SCI_PROJECT \
  K8SCI_REGISTRY_URL \
  K8SCI_REGISTRY_SECRET_NAME \
  K8SCI_IMAGE_TAG \
)
for var_name in "${required_vars[@]}"
do
  if [ -z "$(eval "echo \$$var_name")" ]; then
    echo "Missing environment variable $var_name"
    exit 1
  fi
done

# buildkit
export K8SCI_BUILDKIT_IMAGE=${K8SCI_BUILDKIT_IMAGE:-"moby/buildkit"}
export K8SCI_BUILDKIT_TAG=${K8SCI_BUILDKIT_TAG:-"v0.8.1-rootless"}
# export K8SCI_BUILDKIT_TAG=${K8SCI_BUILDKIT_TAG:-"master-rootless"}

# build
export K8SCI_BUILD_CONTEXT=${K8SCI_BUILD_CONTEXT:-"."}
export K8SCI_BUILD_ARGS=${K8SCI_BUILD_ARGS:-""}

# registry
export K8SCI_REGISTRY_USER_KEY=${K8SCI_REGISTRY_USER_KEY:-"user"}
export K8SCI_REGISTRY_PASS_KEY=${K8SCI_REGISTRY_PASS_KEY:-"pass"}

# context vars
if [ -n "$K8SCI_CONTEXT" ]; then
  export K8SCI_BUILD_DOCKERFILE=${K8SCI_BUILD_DOCKERFILE:-"packages/$K8SCI_CONTEXT/"}
  export K8SCI_REGISTRY_PUSH_PATH=${K8SCI_REGISTRY_PUSH_PATH:-"$K8SCI_PROJECT/$K8SCI_CONTEXT"}
else
  export K8SCI_REGISTRY_PUSH_PATH=${K8SCI_REGISTRY_PUSH_PATH:-"$K8SCI_PROJECT/$K8SCI_PROJECT"}
fi
export K8SCI_REGISTRY_PUSH_TAG=$K8SCI_IMAGE_TAG
export K8SCI_REGISTRY_CACHE_TAG=${K8SCI_REGISTRY_CACHE_TAG:-"buildcache"}

# final and cache registry can be same or decoupled (default to same)
export K8SCI_REGISTRY_CACHE_URL=${K8SCI_REGISTRY_CACHE_URL:-"$K8SCI_REGISTRY_URL"}
export K8SCI_REGISTRY_CACHE_PUSH_PATH=${K8SCI_REGISTRY_CACHE_PUSH_PATH:-"$K8SCI_REGISTRY_PUSH_PATH"}
export K8SCI_REGISTRY_CACHE_SECRET_NAME=${K8SCI_REGISTRY_CACHE_SECRET_NAME:-"$K8SCI_REGISTRY_SECRET_NAME"}
export K8SCI_REGISTRY_CACHE_USER_KEY=${K8SCI_REGISTRY_CACHE_USER_KEY:-"$K8SCI_REGISTRY_USER_KEY"}
export K8SCI_REGISTRY_CACHE_PASS_KEY=${K8SCI_REGISTRY_CACHE_PASS_KEY:-"$K8SCI_REGISTRY_PASS_KEY"}

# run job
cat $(dirname $0)/build-job.yaml | gomplate | kubectl -n $K8SCI_K8S_NS create -f -
