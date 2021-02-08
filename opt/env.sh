#!/bin/sh
set -e

export JOB_ID=${JOB_ID:-"$(uuidgen)"}

export K8S_NS=${K8S_NS:-"k8s-jobs"}

export K8S_TOKEN_SECRET_NAME=${K8S_TOKEN_SECRET_NAME:-"k8s"}
export K8S_TOKEN_SECRET_KEY=${K8S_TOKEN_SECRET_KEY:-"token"}

export GIT_BRANCH_DEFAULT=${GIT_BRANCH_DEFAULT:-"master"}
export GIT_BRANCH=${GIT_BRANCH:-"$GIT_BRANCH_DEFAULT"}

export CI_CONTEXT=${CI_CONTEXT:-""}
export CI_PRE_BUILD_SCRIPT=${CI_PRE_BUILD_SCRIPT:-""}
export CI_POST_BUILD_SCRIPT=${CI_POST_BUILD_SCRIPT:-""}
export CI_PRE_DEPLOY_SCRIPT=${CI_PRE_DEPLOY_SCRIPT:-""}
export CI_POST_DEPLOY_SCRIPT=${CI_POST_DEPLOY_SCRIPT:-""}
export CI_PRODUCTION=${CI_PRODUCTION:-""}

# load variables from webhook url
if [ -n "$CI_BRANCH" ]; then
  export GIT_BRANCH=$CI_BRANCH
fi

export SLUG_MAXSIZE=32
export IMAGE_TAG=$(echo $GIT_BRANCH | sed -e 's/[^[:alnum:].]/-/g' | cut -c1-${SLUG_MAXSIZE})

# build vars
if [ -n "$CI_CONTEXT" ]; then
  export BUILD_DOCKERFILE=packages/$CI_CONTEXT/
  export REGISTRY_PUSH_PATH=$PROJECT/$CI_CONTEXT
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
if [ -n "$CI_CONTEXT" ]; then
  export IMAGE_PATH=$PROJECT/$CI_CONTEXT
  export HELM_CHART=${HELM_CHART:-"packages/$CI_CONTEXT/.k8s"}
  export HELM_RELEASE=${HELM_RELEASE:-"$CI_CONTEXT"}
fi
export HELM_CHART=${HELM_CHART:-".k8s"}
export HELM_RELEASE=${HELM_RELEASE:-"$PROJECT"}

export DOMAIN_SLUG=$(echo $GIT_BRANCH | sed -e 's/[^[:alnum:]]/-/g' | cut -c1-${SLUG_MAXSIZE})

if [ -z "$CI_PRODUCTION" ]; then
  export K8S_DEPLOY_NS="${PROJECT}-$(echo $GIT_BRANCH | sed -e 's/[^[:alnum:]]/-/g' | cut -c1-${SLUG_MAXSIZE})"
  export DB_NAME="${PROJECT}_$(echo $GIT_BRANCH | sed -e 's/[^[:alnum:]]/_/g' | cut -c1-${SLUG_MAXSIZE})"
else
  export K8S_DEPLOY_NS="${PROJECT}"
  export DB_NAME="${PROJECT}"
fi

if [ -f "/opt/env.hook.sh" ]; then
  . /opt/env.hook.sh
fi