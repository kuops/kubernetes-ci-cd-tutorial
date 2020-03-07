### Install Gitea

Create data directory on gitea node

```
# change node name to your gitea node
export GITEA_NODE_NAME="kube-master1"
# login the node create directory
mkdir -p /data/gitea
mkdir -p /var/lib/gitea
```

Install the gitea server

```
sed "s@GITEA_NODE_NAME@${GITEA_NODE_NAME}@g" gitea/gitea.yaml
kubectl create ns gitea
kubectl apply -n gitea -f gitea/gitea.yaml
```

Create Gitea virtualservice, access from `http://argo.{.INGRESS_NODE_IP}.nip.io`

```bash
# export ingressgateway node ip
export INGRESS_NODE_IP=$(kubectl get nodes ${NODE_NAME} -o jsonpath='{ .status.addresses[?(@.type=="InternalIP")].address }')
# replace the {.INGRESS_NODE_IP} to ingressgateway node ip
make build
# apply gitea virtualservice
kubectl apply -n gitea  -f gitea/gitea-vs.yaml
```