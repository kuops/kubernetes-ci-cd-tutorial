# Install Argoworkflow

<!-- markdownlint-disable MD013 -->
Install argo cli

> argo command need kubectl config

```bash
curl -Lo /usr/local/bin/argo https://github.com/argoproj/argo/releases/download/v2.6.1/argo-linux-amd64
chmod +x /usr/local/bin/argo
```

Install Argoworkflow for Continuous integration

```bash
kubectl create namespace argo
kubectl apply -n argo -f https://raw.githubusercontent.com/argoproj/argo/v2.6.1/manifests/quick-start-mysql.yaml
```

Create Argoflow UI virtualservice, access Argo UI from `http://argo.{.INGRESS_NODE_IP}.nip.io`

```bash
# export ingressgateway node ip
export INGRESS_NODE_IP=$(kubectl get nodes ${NODE_NAME} -o jsonpath='{ .status.addresses[?(@.type=="InternalIP")].address }')
# replace the {.INGRESS_NODE_IP} to ingressgateway node ip
make build
# apply argo virtualservice
kubectl apply -n argo  -f argo/argo-workflow-vs.yaml
```
