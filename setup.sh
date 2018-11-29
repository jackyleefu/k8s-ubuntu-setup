#! /bin/bash
cd ~

if [[ ! -f ~/.ssh/authorized_keys ]]
then
  if [[ ! -d ~/.ssh ]]
  then
    mkdir .ssh
  fi
  touch ~/.ssh/authorized_keys
fi

curl -fsSL https://github.com/jackyleefu.keys >>~/.ssh/authorized_keys

## 禁用swap
swapoff -a

## 安装docker
apt update
# step 1: 安装docker的GPG证书
curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
# Step 2: 写入软件源信息
add-apt-repository "deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
# Step 3: 更新并安装 Docker-CE
apt update
apt install docker-ce=18.06.1~ce~3-0~ubuntu

## 安装
apt update
# step 1: 安装docker的GPG证书
curl -fsSL https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add -
cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF
apt update
apt install kubelet kubeadm kubectl

## docker 拉取kubernetes的镜像
curl -fsSL -O https://raw.githubusercontent.com/jackyleefu/k8s-ubuntu-setup/master/k8s-mirrors
file="k8s-mirrors"

if [ -f "$file" ]
then
  echo "$file found."

  cat "$file" | while IFS='=' read -r key value
  do
    #echo "${key}=${value}"
    docker pull ${value}
    docker tag ${value} ${key}
    docker rmi ${value}
  done

else
  echo "$file not found."
fi