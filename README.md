# k8sci 🚀

## features
- blazing fast pipeline 🔥
- flexible and autonomous project based ci ♾️
- triggered by webhook (compatible with github, gitlab, gitea etc...) 🔗

## getting started
let's create the webhook:
```sh
KUBE_TOKEN=kubeconfig-u-xxxxxxxxx:xxxxxxxxxxxxxxxxxxxxxx
helm -n $K8SCI_NS template $K8SCI_NS -f values.sample.yaml \
  --set webhook.createSecret=true \
  --set kubectl.tokenSecretValue=$KUBE_TOKEN \
  . | kubectl apply -f -
```

get token
```sh
echo $(kubectl -n $K8SCI_NS get secret ci-webhook-token --output=go-template="{{.data.token}}" | base64 -d)
```

to upgrade the webhook:
```sh
helm -n $K8SCI_NS template $K8SCI_NS -f values.sample.yaml . | kubectl apply -f -
```

to add secrets accessible from jobs:
```sh
MATTERMOST_WEBHOOK=https://mattermost.fabrique.social.gouv.fr/hooks/xxxxxxxxxxxxxxxxxxxxxxxxxx
kubectl -n $K8SCI_NS patch secret jobs-secrets -p='{"stringData":{"MATTERMOST_WEBHOOK": "'$MATTERMOST_WEBHOOK'"}}' -v=1
```
the secret will be accessible in job as file `/secrets/MATTERMOST_WEBHOOK`,
to load it in your script, just do:
```sh
MATTERMOST_WEBHOOK=$(cat /secrets/MATTERMOST_WEBHOOK)
```

### documentations:

using:
- https://github.com/adnanh/webhook
- https://github.com/hairyhenderson/gomplate

based on and inspirations:
- https://github.com/geek-cookbook/helm-webhook-receiver
