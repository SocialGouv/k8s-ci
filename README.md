# k8s-ci ✨☄️

## features
- blazing fast pipeline 🚀
- flexible and autonomous project based ci
- triggered by webhook (compatible with github, gitlab, gitea etc...)

## getting started
let's create the webhook:
```sh
KUBE_TOKEN=kubeconfig-u-xxxxxxxxx:xxxxxxxxxxxxxxxxxxxxxx
helm -n $K8SCI_NS template $K8SCI_NS -f values.sample.yaml \
  --set kubectl.tokenSecretValue=$KUBE_TOKEN \
  --set webhook.createSecret=true \
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


### documentations:

using:
- https://github.com/adnanh/webhook
- https://github.com/hairyhenderson/gomplate

based on and inspirations:
- https://github.com/geek-cookbook/helm-webhook-receiver
