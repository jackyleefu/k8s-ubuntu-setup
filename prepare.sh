#! /bin/bash

## 禁用防火墙
#sudo systemctl stop firewalld
#sudo systemctl disable firewalld

## 禁用selinux
#sudo setenforce 0
#sudo sed -i "s///g" /etc/selinux/config

## 禁用内存交换
sudo swapoff -a
sudo sed -i "s/^\/swap\.img/#\/swap\.img/g" /etc/fstab

## 启用ip_forward
sudo sysctl -wq net.ipv4.ip_forward=1
sudo su -c "echo 'net.ipv4.ip_forward = 1' >>/etc/sysctl.conf"

## 阻止DNS回路
sudo sed -i 's/^#DNS=/DNS=114\.114\.114\.114/g' /etc/systemd/resolved.conf
sudo systemctl restart systemd-resolved

## 安装docker
if [[ -z `which docker` ]]
then 
  echo "installing docker"
  sudo apt update
  # step 1: 安装docker的GPG证书
  curl -fsSL http://mirrors.aliyun.com/docker-ce/linux/ubuntu/gpg | sudo apt-key add -
  # Step 2: 写入软件源信息
  sudo add-apt-repository "deb [arch=amd64] http://mirrors.aliyun.com/docker-ce/linux/ubuntu $(lsb_release -cs) stable"
  # Step 3: 更新并安装 Docker-CE
  sudo apt update
  sudo apt install -y docker-ce=18.06.1~ce~3-0~ubuntu
  echo "installed docker"
fi

## 安装 kubelet kubeadm kubectl
if [[ -z `which kubeadm` ]]
then 
  echo "installing kubernetes tools"
  sudo apt update
  # step 1: 安装docker的GPG证书
  curl -fsSL https://mirrors.aliyun.com/kubernetes/apt/doc/apt-key.gpg | sudo apt-key add -
  sudo su -c "cat <<EOF >/etc/apt/sources.list.d/kubernetes.list
deb https://mirrors.aliyun.com/kubernetes/apt/ kubernetes-xenial main
EOF
"
  sudo apt update
  sudo apt install -y kubelet kubeadm kubectl
  echo "installed kubernetes tools"
fi