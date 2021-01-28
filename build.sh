#!/bin/sh

TAG=${1:-latest}
docker build -t registry.gitlab.factory.social.gouv.fr/devthejo/webhook-k8s-ci:$TAG .
docker push registry.gitlab.factory.social.gouv.fr/devthejo/webhook-k8s-ci:$TAG
