## kubernetes-ci-cd-tutorial


### 环境准备

1.  Kubernetes 集群, 如果没有可以使用 `https://github.com/kuops/Scripts/tree/master/vagrant/kubeadm` 创建集群
2.  安装 `Helm` 和 `Tiller`
3.  安装 ingress
4.  有一个 `storageclass`



### step 1 

准备 `nexus` 和 `jenkins`

```
helm upgrade --install myjenkins step1/jenkins/
helm upgrade --install mynexus step1/sonatype-nexus/
```

### step 2 

- PHP demo 使用 https://github.com/kuops/php-example-app.git



