docker pull registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy:v1.12.3
docker tag registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy:v1.12.3 k8s.gcr.io/kube-proxy:v1.12.3
docker rmi registry.cn-hangzhou.aliyuncs.com/google_containers/kube-proxy:v1.12.3