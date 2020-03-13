## Install Jenkins


select a node as jenkins node

```bash
# label node
kubectl label nodes kube-node1 node-role.kubernetes.io/jenkins=jenkins
# creat jenkins home on kube-node1
mkdir -p /data/jenkins
# apply app
kubectl create ns jenkins
kubectl apply -f jenkins/jenkins.yaml
```

Create Jenkins virtualservice, access from `http://jenkins.{.INGRESS_NODE_IP}.nip.io`

```bash
# export ingressgateway node ip
export INGRESS_NODE_IP=$(kubectl get nodes ${INGRESS_NODE_NAME} -o jsonpath='{ .status.addresses[?(@.type=="InternalIP")].address }')
# replace the {.INGRESS_NODE_IP} to ingressgateway node ip
make build
# apply gitea virtualservice
kubectl apply -f jenkins/jenkins-vs.yaml
```

Using Browser access `http://jenkins.{.INGRESS_NODE_IP}.nip.io`, Login with user `admin` and password `admin`:

