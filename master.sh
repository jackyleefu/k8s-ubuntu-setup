## docker 提前从gcr的国内仓库里拉取kubernetes的核心image, 并修改为原image的tag
echo "installing kubernetes images"
curl -fsSL -O https://raw.githubusercontent.com/jackyleefu/k8s-ubuntu-setup/master/k8s-mirrors
file="k8s-mirrors"

if [ -f "$file" ]
then
  echo "$file found."

  cat "$file" | while IFS='=' read -r key value
  do
    #echo "${key}=${value}"
    if [[ -z `docker images | grep ${key%:*}` ]]
    then
      docker pull ${value}
      docker tag ${value} ${key}
      docker rmi ${value}
    fi
  done

else
  echo "$file not found."
fi
echo "installed kubernetes images"

# master 初始化
kubeadm init --kubernetes-version=v1.12.3 --pod-network-cidr=10.244.0.0/16

# 复制管理员的配置文件到kubectl的工作目录 
mkdir -p $HOME/.kube && sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config && sudo chown $(id -u):$(id -g) $HOME/.kube/config

# 安装网络附件
kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml
