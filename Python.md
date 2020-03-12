python flask 仓库地址

```
https://github.com/kuops/python-example-app.git
```

使用 helm 部署 python 项目

```
git clone https://github.com/kuops/python-example-app.git
helm upgrade --install python-app python-example-app/Charts --namespace=dev  --wait
```

同样的，这里我们也需要 https 的 secret ，以便使用 ingress 访问, 在 Charts/temlates 目录中:

```
apiVersion: v1
data:
  tls.crt: <your_cert>
  tls.key: <key_key>
kind: Secret
metadata:
  name: python-tls-certs
type: kubernetes.io/tls

```

创建 servicemonitor

```
kubectl apply -f python-example-app/serviceMonitor.yaml
```

测试访问

```
#错误请求
ab -c 50 -n 200 https://python.k8s.kuops.com/error
#正常其他请求
ab -c 50 -n 200 https://python.k8s.kuops.com/one
ab -c 50 -n 200 https://python.k8s.kuops.com/two
ab -c 50 -n 200 https://python.k8s.kuops.com/three
ab -c 50 -n 200 https://python.k8s.kuops.com/four
```

grafana dashboard

```
python-example-app/grafana/dashboard.json
```

## 示例 dashboard 指标

### 每秒请求数

每秒成功的 Flask 请求数。按 URI 显示。

```
rate(
  flask_http_request_duration_seconds_count{status="200"}[30s]
)
```

### 每秒错误数

每秒失败（HTTP 200）响应的数量。

```
sum(
  rate(
    flask_http_request_duration_seconds_count{status!="200"}[30s]
  )
)
```

### 每分钟的总请求数

每隔一分钟测量的请求总数。按 HTTP 响应状态代码显示。

```
increase(
  flask_http_request_total[1m]
)
```

### 30 秒内平均响应时间

成功请求的间隔为 30 秒的平均响应时间。每条路径显示。

```
rate(
  flask_http_request_duration_seconds_sum{status="200"}[30s]
)
 /
rate(
  flask_http_request_duration_seconds_count{status="200"}[30s]
)
```

### 响应低于 250 ms 的请求

成功请求的百分比在 1/4 秒内完成。每条路径显示。

```
increase(
  flask_http_request_duration_seconds_bucket{status="200",le="0.25"}[30s]
)
 / ignoring (le)
increase(
  flask_http_request_duration_seconds_count{status="200"}[30s]
)
```

### 请求持续时间[s] - p50

在过去 30 秒内请求持续时间的第 50 个百分位数。换句话说，这些时间中，有一半的请求以（min / max / avg）结束。每条路径显示。

```
histogram_quantile(
  0.5,
  rate(
    flask_http_request_duration_seconds_bucket{status="200"}[30s]
  )
)
```

### 请求持续时间[s] - p90

The 90th percentile of request durations over the last 30 seconds. In other words, 90 percent of the requests finish in (min/max/avg) these times. Shown per path.

```
histogram_quantile(
  0.9,
  rate(
    flask_http_request_duration_seconds_bucket{status="200"}[30s]
  )
)
```

### 内存使用率

```
process_resident_memory_bytes{job="python-app-flask-app"}
```

### CPU 使用率

```
process_resident_memory_bytes{job="python-app-flask-app"}
```
