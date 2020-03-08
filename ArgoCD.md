### Install ArgoCD

Install ArgoCD

```bash
kubectl create ns argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v1.4.2/manifests/install.yaml
```

Create ArgoCD UI virtualservice, access Argo UI from `http://argocd.{.INGRESS_NODE_IP}.nip.io`

```bash
# export ingressgateway node ip
export INGRESS_NODE_IP=$(kubectl get nodes ${NODE_NAME} -o jsonpath='{ .status.addresses[?(@.type=="InternalIP")].address }')
# replace the {.INGRESS_NODE_IP} to ingressgateway node ip
make build
# apply argo virtualservice
kubectl apply -n argocd  -f argo/argo-cd-vs.yaml
```

Install ArgoCD Cli

```
curl -SL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/download/v1.4.2/argocd-linux-amd64
chmod +x /usr/local/bin/argocd
```

Login Argocd,

```
PASSWORD=$(kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name|grep -Po '/\K[\w-]+')
argocd  login argocd.10.7.0.102.nip.io:443 --username admin --password $PASSWORD
```
