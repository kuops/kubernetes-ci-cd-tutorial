# kubernetes-ci-cd-tutorial

This Repository is a Kubernetes CI/CD tutorial for simple apps.

## Dependencies

-  **kubernetes**: 1.17.3
-  **Helm**: 3.1.1
-  **Istio**: 1.4
-  **ArgoCD**: 1.4.2
-  **Tekton**: 2.204
-  **DockerRegistry**: hub.docker.com

## Prepare Settings

### Install istio

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

Chagne All virtualservice

```bash
# export ingressgateway node ip
export INGRESS_NODE_IP=$(kubectl get nodes ${NODE_NAME} -o jsonpath='{ .status.addresses[?(@.type=="InternalIP")].address }')
# replace the {.INGRESS_NODE_IP} to ingressgateway node ip
make build
```

### Running CI/CD examples

1. [simple web application for golang](Go.md)
