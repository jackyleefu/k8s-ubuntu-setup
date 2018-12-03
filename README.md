- every node:  

        $ bash -c "$(curl -fsSL https://raw.githubusercontent.com/jackyleefu/k8s-ubuntu-setup/master/prepare.sh)"

- master node:  
    
        $ bash -c "$(curl -fsSL https://raw.githubusercontent.com/jackyleefu/k8s-ubuntu-setup/master/master.sh)"

- node:  
    1. first
            
            $ bash -c "$(curl -fsSL https://raw.githubusercontent.com/jackyleefu/k8s-ubuntu-setup/master/node.sh)"
    2. then

            $ sudo kubeadm join <masterIP>:<masterPort> --token <masterToken> --discovery-token-ca-cert-hash <masterHash>

