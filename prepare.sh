#! /bin/bash

## 设置静态IP
if [[ -z $1 ]]
then
  echo "No IP specified"
  exit 1
fi

ip=echo "$1" | sed 's/\./\\\./g' | sed 's/\//\\\//g'
sed -i "s/\[\]/${ip}/g" /etc/netplan/50-cloud-init.yaml
netplan apply

## 禁用防火墙
#systemctl stop firewalld
#systemctl disable firewalld

## 禁用selinux
#setenforce 0
#sed -i "s///g" /etc/selinux/config

## 禁用内存交换
swapoff -a
sed -i "s/\/swap\.img/#\/swap\.img/g" /etc/fstab

## 启用ip_forward
sysctl -wq net.ipv4.ip_forward=1
echo "net.ipv4.ip_forward = 1" >>/etc/sysctl.conf

## 阻止DNS回路
sed -i 's/#DNS=/DNS=114\.114\.114\.114/g' /etc/systemd/resolved.conf
systemctl restart systemd-resolved

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