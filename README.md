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


## php example

php code repo 开发者使用，在仓库的 ci 文件夹存放 用于 CI 的 Jenkinsfile ,示例地址: 

```
https://github.com/kuops/php-example-app.git
```

php deploy repo 运维人员使用, 仓库地址:

```
https://github.com/kuops/php-infrastructure.git
```

将这两个仓库 fork 到你自己的仓库下面

### php ci

由于使用私有地址，无法使用 webhook 回调，不能使用 pull requirest 触发构建，这里使用 pollSCM 触发构建

```
 triggers {
        pollSCM('*/2 * * * 1-5')
    }
```

修改 pipeline 中的 REGISTRY_URL 为你的地址:

```
environment { 
        REGISTRY_URL = 'docker.k8s.yourdomain.com'
    }
```

首先, 我们创建一个用于存放 composer cache 的 volume, 这个 volume 用于 Jenkins 的 slave 启动

```
kubectl apply -f https://raw.githubusercontent.com/kuops/php-infrastructure/master/composer/pvc.yaml
```

接下来我们创建 CI job `php-ci`,类型为 Pipeline , 按照以下设置 Jenkins , Jenkinsfile 路径为 `ci/Jenkinsfile`

![php-pipeline-ci](images/PHP-CI-Pipeline-Setting.png)

配置完成之后点击构建，就开始执行 CI 操作了。


### php cd 

部署之前我们还需要一个 https 证书，在 php-infrastructure 中将 https 证书修改 voyager/template/secret.yaml

```
apiVersion: v1
data:
  tls.crt: <your_cert>
  tls.key: <key_key>
kind: Secret
metadata:
  name: php-tls-certs
type: kubernetes.io/tls

```

设置 dev 空间拉去镜像 secret

```

kubectl -n dev create secret docker-registry regcred \
    --docker-server=docker.k8s.yourdomain.com \
    --docker-username=admin --docker-password=admin123
```

设置 jenkins cd job `php-cd` pipeline 类型,设置如下：

![PHP-CD-Pipeline-Setting.png](images/PHP-CD-Pipeline-Setting.png)

构建完成之后访问 `https://php.k8s.yourdomain.com/admin`

用户名: `admin@admin.com` , 密码: `password`

![php-example.png](images/php-example.png)
