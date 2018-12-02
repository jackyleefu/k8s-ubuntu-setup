# k8s v1.12.3 kubeadm for ubuntu 18.04 setup
every node:  

    $ sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/jackyleefu/k8s-ubuntu-setup/master/prepare.sh)" -- 192.168.0.50/24

master node:  
    
    $ bash -c "$(curl -fsSL https://raw.githubusercontent.com/jackyleefu/k8s-ubuntu-setup/master/master.sh)"

node:  

    $ bash -c "$(curl -fsSL https://raw.githubusercontent.com/jackyleefu/k8s-ubuntu-setup/master/node.sh) 51"