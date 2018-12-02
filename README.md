# k8s kubeadm for ubuntu 18.04 setup
every node:  

    $ sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/jackyleefu/k8s-ubuntu-setup/master/prepare.sh)"

master node:  
    
    $ bash -c "$(curl -fsSL https://raw.githubusercontent.com/jackyleefu/k8s-ubuntu-setup/master/master.sh)"

node:  

    $ bash -c "$(curl -fsSL https://raw.githubusercontent.com/jackyleefu/k8s-ubuntu-setup/master/node.sh) 51"