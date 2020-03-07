# Deploy GoLang Application with Argo

Deploy GoLang example App on Kubernetes and CI/CD tools using Argoworkflow and ArgoCD

## Quick Start

### Install Argoworkflow

Install argo cli

```
curl -Lo /usr/local/bin/argo https://github.com/argoproj/argo/releases/download/v2.6.1/argo-linux-amd64
chmod +x /usr/local/bin/argo
```

Install Argoworkflow for Continuous integration

```
kubectl create namespace argo
kubectl apply -n argo -f https://raw.githubusercontent.com/argoproj/argo/v2.6.1/manifests/quick-start-mysql.yaml
```

### Start Pipelines

```
argo submit -n argo --watch .argoworkflow.yaml
```
