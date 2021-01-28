# k8s-ci ✨☄️

## features
- build and deploy between 5 minutes and 30 seconds !!! 🚀 
- un système de pipeline parallélisé, build and deploy
- un système de webhook: https://github.com/adnanh/webhook (callable depuis n'importe où: gitlab-ci, github-ci, laptop...)
- intégration buildkit: https://github.com/moby/buildkit
- un déploiment de webhook configurable pour chaque projet
- registry cache et push découplés

## sample

### only build
all context if no specified and monorepo, else normal one job build
branch default to master
https://$MY_PROJECT-webhook-ci.$MY_CLUSTER_HOST/hooks/deploy?token=$TOKEN&branch=master&context=hasura,api,app
```
{
  "jobs": [
    {
      "id": "build-job-24530c68-ea29-4e58-a0f6-c82727cfc51f",
      "contextJobID": "24530c68-ea29-4e58-a0f6-c82727cfc51f",
      "type": "build",
      "context": "hasura",
      "message": "job.batch/build-job-24530c68-ea29-4e58-a0f6-c82727cfc51f created",
      "status": "success"
    },
    {
      "id": "build-job-cd9fb21d-8583-48c7-802a-58c23830ad4d",
      "contextJobID": "cd9fb21d-8583-48c7-802a-58c23830ad4d",
      "type": "build",
      "context": "api",
      "message": "job.batch/build-job-cd9fb21d-8583-48c7-802a-58c23830ad4d created",
      "status": "success"
    },
    {
      "id": "build-job-64509c26-5b9b-42c6-aadf-762dad1eda6d",
      "contextJobID": "64509c26-5b9b-42c6-aadf-762dad1eda6d",
      "type": "build",
      "context": "app",
      "message": "job.batch/build-job-64509c26-5b9b-42c6-aadf-762dad1eda6d created",
      "status": "success"
    }
  ]
}
```


### only deploy, only context app (monorepo)
https://$MY_PROJECT-webhook-ci.$MY_CLUSTER_HOST/hooks/deploy?token=$TOKEN&branch=master&context=app
result:
```
{
  "jobs": [
    {
      "id": "deploy-job-02201239-e03d-405b-834c-ceca549ab685",
      "contextJobID": "02201239-e03d-405b-834c-ceca549ab685",
      "type": "deploy",
      "context": "app",
      "message": "job.batch/deploy-job-02201239-e03d-405b-834c-ceca549ab685 created",
      "status": "success"
    }
  ]
}
```

build and deploy
https://$MY_PROJECT-webhook-ci.$MY_CLUSTER/hooks/build-n-deploy?token=$TOKEN&branch=$MY_GIT_BRANCH
result:
```json
{
  "jobs": [
    {
      "id": "build-job-b7d97728-880c-41e1-aadc-2ea07e258dc5",
      "contextJobID": "b7d97728-880c-41e1-aadc-2ea07e258dc5",
      "type": "build",
      "context": "hasura",
      "message": "job.batch/build-job-b7d97728-880c-41e1-aadc-2ea07e258dc5 created",
      "status": "success"
    },
    {
      "id": "deploy-job-b7d97728-880c-41e1-aadc-2ea07e258dc5",
      "contextJobID": "b7d97728-880c-41e1-aadc-2ea07e258dc5",
      "type": "deploy",
      "context": "hasura",
      "message": "job.batch/deploy-job-b7d97728-880c-41e1-aadc-2ea07e258dc5 created",
      "status": "success"
    },
    {
      "id": "build-job-d1bd91fd-7a61-4722-bf72-5fd237249b01",
      "contextJobID": "d1bd91fd-7a61-4722-bf72-5fd237249b01",
      "type": "build",
      "context": "api",
      "message": "job.batch/build-job-d1bd91fd-7a61-4722-bf72-5fd237249b01 created",
      "status": "success"
    },
    {
      "id": "deploy-job-d1bd91fd-7a61-4722-bf72-5fd237249b01",
      "contextJobID": "d1bd91fd-7a61-4722-bf72-5fd237249b01",
      "type": "deploy",
      "context": "api",
      "message": "job.batch/deploy-job-d1bd91fd-7a61-4722-bf72-5fd237249b01 created",
      "status": "success"
    },
    {
      "id": "build-job-6c5de391-db0f-44ee-926a-ac55185bf84c",
      "contextJobID": "6c5de391-db0f-44ee-926a-ac55185bf84c",
      "type": "build",
      "context": "app",
      "message": "job.batch/build-job-6c5de391-db0f-44ee-926a-ac55185bf84c created",
      "status": "success"
    },
    {
      "id": "deploy-job-6c5de391-db0f-44ee-926a-ac55185bf84c",
      "contextJobID": "6c5de391-db0f-44ee-926a-ac55185bf84c",
      "type": "deploy",
      "context": "app",
      "message": "job.batch/deploy-job-6c5de391-db0f-44ee-926a-ac55185bf84c created",
      "status": "success"
    }
  ]
}
```

### about
Why ?
Doesn't like too much suspens when deploying !
Built with 🔥 🦊 ❤️ 🐺 by 👽
🖖
