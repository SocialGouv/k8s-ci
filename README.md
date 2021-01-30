# k8s-ci ✨☄️

## features
- build and deploy between 5 minutes and 30 seconds !!! 🚀
- un système de pipeline parallélisé, build and deploy
- un système de webhook: https://github.com/adnanh/webhook (callable depuis n'importe où: gitlab-ci, github-ci, laptop...)
- intégration buildkit: https://github.com/moby/buildkit
- un déploiment de webhook configurable pour chaque projet
- registry cache et push découplés
- on-demand customisables hooks


## getting started
create a token as a secret:
```sh
kubectl -n k8s-ci-myproject create secret generic ci-webhook-token \
  --from-literal=token=$(cat /dev/urandom | base64 | head -n 1 |tr -dc '[:alnum:]' |cut -c -32)
```

let's deploy the webhook:
```sh
helm -n k8s-ci-myproject template k8s-ci-myproject -f values.sample.yaml . | kubectl create -f -
```

## examples

### only build
all context if no specified and monorepo, else normal one job build
branch default to master

https://$MY_PROJECT-webhook-ci.$MY_CLUSTER_HOST/hooks/ci?action=deploy&token=$TOKEN&branch=master&context=hasura,api,app

```json
{
  "jobs": [
    {
      "id": "24530c68-ea29-4e58-a0f6-c82727cfc51f",
      "context": "hasura",
      "message": "job.batch/build-job-24530c68-ea29-4e58-a0f6-c82727cfc51f created",
      "status": "success"
    },
    {
      "id": "cd9fb21d-8583-48c7-802a-58c23830ad4d",
      "context": "api",
      "message": "job.batch/build-job-cd9fb21d-8583-48c7-802a-58c23830ad4d created",
      "status": "success"
    },
    {
      "id": "64509c26-5b9b-42c6-aadf-762dad1eda6d",
      "context": "app",
      "message": "job.batch/build-job-64509c26-5b9b-42c6-aadf-762dad1eda6d created",
      "status": "success"
    }
  ]
}
```


### only deploy, only context app (monorepo)

https://$MY_PROJECT-webhook-ci.$MY_CLUSTER_HOST/hooks/ci?action=deploy&token=$TOKEN&branch=master&context=app

result:
```json
{
  "jobs": [
    {
      "id": "02201239-e03d-405b-834c-ceca549ab685",
      "context": "app",
      "message": "job.batch/deploy-job-02201239-e03d-405b-834c-ceca549ab685 created",
      "status": "success"
    }
  ]
}
```

build and deploy

https://$MY_PROJECT-webhook-ci.$MY_CLUSTER/hooks/ci?action=myCustomPipeline&token=$TOKEN&branch=$MY_GIT_BRANCH

result:
```json
{
  "jobs": [
    {
      "id": "b7d97728-880c-41e1-aadc-2ea07e258dc5",
      "context": "hasura",
      "message": "job.batch/build-job-b7d97728-880c-41e1-aadc-2ea07e258dc5 created",
      "status": "success"
    },
    {
      "id": "d1bd91fd-7a61-4722-bf72-5fd237249b01",
      "context": "api",
      "message": "job.batch/build-job-d1bd91fd-7a61-4722-bf72-5fd237249b01 created",
      "status": "success"
    }
  ]
}
```

### documentations:

using:
- https://github.com/adnanh/webhook
- https://github.com/moby/buildkit
- https://github.com/hairyhenderson/gomplate

based on and inspirations:
- https://github.com/geek-cookbook/helm-webhook-receiver

### TODO (help and collab is very welcome ;))

- stop webhook job based on annotations
- expose logs (eg: from loki)
- cache system for running tests (based on k8s pvc)
- clean and simple pipeline configuration system:
  fractal arborescence with optional loops and parametrable parallelisation
  (like in snip, a go ops tool I've developed, can be a good base)

eg for pipeline definition:
```yaml
actions:
- name: build-packages
  parallel: true
  loop_on:
    - CONTEXT: app
    - CONTEXT: api
    - CONTEXT: hasura
  actions:
    - action: lint
    - action: test
    - action: build
- action: create-namespace
- action: create-db
- name: deploy
  parallel: true
  loop_on:
    - CONTEXT: app
    - CONTEXT: api
    - CONTEXT: hasura
  actions:
    - action: deploy
- action: notify-mattermost
```

### about
Why ?

Doesn't like too much suspens when deploying !

Built with 🔥 🦊 ❤️ 🐺 by 👽

🖖
