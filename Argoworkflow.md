### Install Argoworkflow

Install argo cli

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
kubectl apply -n argo  -f argo/argo-workflow-vs.yaml
```
