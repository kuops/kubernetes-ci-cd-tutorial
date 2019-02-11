# kubernetes-ci-cd-tutorial


## 前提条件

1.  Kubernetes 集群, 如果没有可以参考 [vagrant-kubeadm](https://github.com/kuops/vagrant-kubeadm) 创建集群
2. 需要有 `Helm`,`ingress`,`istio`,`storageClass`,`prometheus`
3. 需要有 https 证书 `*.k8s.youdomain.com`


## Nexus3

设置 nexusProxy 的 value 值,nexusDockerHost 是 docker 用来 push 镜像的域名，nexusHttpHost 是 nexus web 端口

```
  env:
    nexusDockerHost: docker.k8s.yourdomain.com
    nexusHttpHost: nexus.k8s.yourdomain.com
    enforceHttps: true
    cloudIamAuthEnabled: false
```

设置 ingress 的 value 值, tls 值是你的证书的 tls-secret

```
annotations:
    nginx.ingress.kubernetes.io/proxy-body-size: "0"
    nginx.ingress.kubernetes.io/proxy-read-timeout: "600"
    nginx.ingress.kubernetes.io/proxy-send-timeout: "600"
  tls:
    enabled: true
    secretName: default-tls-certs
```

安装 nexus3 ，nexus 可以作为 java,python,docker 仓库

```
helm upgrade --install my-nexus3 sonatype-nexus
```

配置 nexus 仓库，添加 docker(hosted) 仓库, 查看[官方配置说明](https://github.com/travelaudience/kubernetes-nexus/blob/master/docs/admin/configuring-nexus.md)

![docker-hosted](https://raw.githubusercontent.com/travelaudience/kubernetes-nexus/master/docs/admin/docker-hosted.png)

访问 https://nexus.k8s.yourdomain.com, 用户名 `admin`,密码 `admin123`。

测试上传镜像, login 用户密码和 nexus 一致

```
docker login docker.k8s.yourdomain.com
docker pull alpine
docker tag alpine docker.k8s.yourdomain.com/alpine:latest
docker push docker.k8s.yourdomain.com/alpine:latest
```

创建 Private Registry Secret , 需要将 docker(hosted) 中设置 `enable docker v1 api`

```

# 因为我们需要在 CI 中需要使用 docker client push 镜像,需要使用此 secret
kubectl create secret generic regcred --from-file=.dockerconfigjson=$HOME/.docker/config.json
```

## Jenkins

设置 ingress 的值 `secretName`,`HostName`,`hosts`

```
  HostName: jenkins.k8s.yourdomain.com

  Ingress:
    ...
    TLS:
    - secretName: default-tls-certs
      hosts:
        - jenkins.k8s.yourdomain.com
```

安装 Jenkins

```
helm upgrade --install my-jenkins jenkins
```

访问 jenkins , 域名 `https://jenkins.k8s.yourdomain.com`,用户名 `admin`, 密码 `admin`


## 部署程序

- [使用 Jenkins 和 helm chart 部署 laravel(php) 程序](PHP.md)

- [使用 helm 部署 flask(python) 程序，并使用 Prometheus 获取指标](Python.md)


