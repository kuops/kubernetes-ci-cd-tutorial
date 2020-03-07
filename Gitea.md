### Install Gitea

Create data directory on gitea node

```
# change node name to your gitea node
export GITEA_NODE_NAME="kube-master1"
# login the node create directory
mkdir -p /data/gitea
mkdir -p /var/lib/gitea
```

install the gitea server

```
sed "s@GITEA_NODE_NAME@${GITEA_NODE_NAME}@g" gitea/gitea.yaml
kubectl create ns gitea
kubectl apply -n gitea -f gitea/gitea.yaml
```

