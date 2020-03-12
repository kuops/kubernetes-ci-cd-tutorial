# kubernetes-ci-cd-tutorial

This Repository is a Kubernetes CI/CD tutorial for simple apps.

## Prepare enviroment

Run this examples you need prepare enviroment:

- **kubernetes**: 1.17.3
- **istioctl**: 1.4.5

## Getting Started

```bash
# clone this project
git clone https://github.com/kuops/kubernetes-ci-cd-tutorial.git
# change directory for tutorial
cd kubernetes-ci-cd-tutorial
```

## Install Dependencies

1. [Install Istio](Istio.md)

2. [Install Argoworkflow](Argoworkflow.md)

3. [Install Gitea](Gitea.md)

4. [Install Argocd](Argocd.md)

if Install finish you have this variables

```bash
export INGRESS_NODE_NAME=<you node name>
export INGRESS_NODE_IP=$(kubectl get nodes ${INGRESS_NODE_NAME} -o jsonpath='{ .status.addresses[?(@.type=="InternalIP")].address }')
export GITEA_NODE_NAME=<username>
export ARGOCD_PASSWORD=$(kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name|grep -Po '/\K[\w-]+')
```

## Running CI/CD examples

1. [simple web application for golang wich argoworkflow and argocd](Go.md)
