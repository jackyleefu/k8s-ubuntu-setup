#! /bin/bash

if [[ `whoami` != 'root']]
then
  echo 'must switch to root'
  exit 1
fi

cd $HOME

## 启用net.ipv4.ip_forward
echo "net.ipv4.ip_forward = 1" >>/etc/sysctl.conf

## 从github的用户中下载SSH客户端的公钥
echo "downloading ssh pub"
if [[ ! -f ~/.ssh/authorized_keys ]]
then
  if [[ ! -d ~/.ssh ]]
  then
    mkdir .ssh
  fi
  touch ~/.ssh/authorized_keys
fi

sudo -s "curl -fsSL https://github.com/jackyleefu.keys >>$HOME/.ssh/authorized_keys"
echo "downloaded ssh pub"

## 安装docker
if [[ -z `which docker` ]]
then 
  echo "installing docker"
  apt update
  # step 1: 安装docker的GPG证书
  curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
  # Step 2: 写入软件源信息
  add-apt-repository "deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
  # Step 3: 更新并安装 Docker-CE
  apt update
  apt install -y docker-ce=18.06.1~ce~3-0~ubuntu
  echo "installed docker"
fi

## 安装 kubelet kubeadm kubectl
if [[ -z `which kubeadm` ]]
then 
  echo "installing kubernetes tools"
  apt update
  # step 1: 安装docker的GPG证书
  curl -fsSL https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | apt-key add -
  cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF
  apt update
  apt install -y kubelet kubeadm kubectl
  echo "installed kubernetes tools"
fi

## docker 提前从gcr的国内镜像里拉取kubernetes的核心image, 并修改为原image的tag
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