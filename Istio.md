# Install istio

Install the offical recommend components

```bash
# apply the default istio compoments
istioctl manifest apply
```

Change default ingressgateway deployment to ingressgateway node

```bash
# change node name to your ingressgateway node
export INGRESS_NODE_NAME="kube-node1"
# add ingressgateway label with the node
kubectl label node $NODE_NAME node-role.kubernetes.io/ingressgateway=ingressgateway
```

Using `hostPort` expose istio-ingressgateway

```bash
# the ingressgateway yaml append hostport
kubectl apply -f istio/istio-ingressgateway.yaml
```

Build All virtualservice

```bash
# export ingressgateway node ip
export INGRESS_NODE_IP=$(kubectl get nodes ${NODE_NAME} -o jsonpath='{ .status.addresses[?(@.type=="InternalIP")].address }')
# replace the {.INGRESS_NODE_IP} to ingressgateway node ip
make build
```
