#!/bin/sh
set -e

export JOB_ID=${JOB_ID:-"$(uuidgen)"}

export K8S_NS=${K8S_NS:-"k8s-jobs"}

export K8S_TOKEN_SECRET_NAME=${K8S_TOKEN_SECRET_NAME:-"k8s"}
export K8S_TOKEN_SECRET_KEY=${K8S_TOKEN_SECRET_KEY:-"token"}

export GIT_BRANCH_DEFAULT=${GIT_BRANCH_DEFAULT:-"master"}
export GIT_BRANCH=${GIT_BRANCH:-"$GIT_BRANCH_DEFAULT"}

export CONTEXT=${CONTEXT:-""}
export PRE_DEPLOY_SCRIPT=${POST_DEPLOY_SCRIPT:-""}
export POST_DEPLOY_SCRIPT=${POST_DEPLOY_SCRIPT:-""}
export WAIT_FOR_JOB=${WAIT_FOR_JOB:-""}
export PRODUCTION=${PRODUCTION:-""}

# load variables from webhook url
if [ -n "$BRANCH" ]; then
  export GIT_BRANCH=$BRANCH
fi

export SLUG_MAXSIZE=32
export IMAGE_TAG=$(echo $GIT_BRANCH | sed -e 's/[^[:alnum:].]/-/g' | cut -c1-${SLUG_MAXSIZE})

# build vars
if [ -n "$CONTEXT" ]; then
  export BUILD_DOCKERFILE=packages/$CONTEXT/
  export REGISTRY_PUSH_PATH=$PROJECT/$CONTEXT
else
  export REGISTRY_PUSH_PATH=$PROJECT/$PROJECT
fi
export REGISTRY_PUSH_TAG=$IMAGE_TAG
export REGISTRY_CACHE_TAG=${REGISTRY_CACHE_TAG:-"buildcache"}
# if final and cache registry are decoupled
export REGISTRY_CACHE_URL=${REGISTRY_CACHE_URL:-"$REGISTRY_URL"}
export REGISTRY_CACHE_PUSH_PATH=${REGISTRY_CACHE_PUSH_PATH:-"$REGISTRY_PUSH_PATH"}
export REGISTRY_CACHE_SECRET_NAME=${REGISTRY_CACHE_SECRET_NAME:-"$REGISTRY_SECRET_NAME"}
export REGISTRY_CACHE_USER_KEY=${REGISTRY_CACHE_USER_KEY:-"$REGISTRY_USER_KEY"}
export REGISTRY_CACHE_PASS_KEY=${REGISTRY_CACHE_PASS_KEY:-"$REGISTRY_PASS_KEY"}


# deploy vars
if [ -n "$CONTEXT" ]; then
  export IMAGE_PATH=$PROJECT/$CONTEXT
  export HELM_CHART=${HELM_CHART:-"packages/$CONTEXT/.k8s"}
  export HELM_RELEASE=${HELM_RELEASE:-"$CONTEXT"}
fi
export HELM_CHART=${HELM_CHART:-".k8s"}
export HELM_RELEASE=${HELM_RELEASE:-"$PROJECT"}

export DOMAIN_SLUG=$(echo $GIT_BRANCH | sed -e 's/[^[:alnum:]]/-/g' | cut -c1-${SLUG_MAXSIZE})
export K8S_DEPLOY_NS="${PROJECT}-$(echo $GIT_BRANCH | sed -e 's/[^[:alnum:]]/-/g' | cut -c1-${SLUG_MAXSIZE})"
export DB_NAME="${PROJECT}_$(echo $GIT_BRANCH | sed -e 's/[^[:alnum:]]/-/g' | cut -c1-${SLUG_MAXSIZE})"


if [ -f "$(dirname $0)/env.hook.sh" ]; then
  . $(dirname $0)/env.hook.sh
fi