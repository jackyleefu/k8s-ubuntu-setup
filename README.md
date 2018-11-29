# k8s-ubuntu-setup
1. root Login
2. disable swap

    1. swap off

            # swapoff -a
    2. comment swap:

            # vi /etc/fstab
3. exec:  
    # bash -c "$(curl -fsSL https://raw.githubusercontent.com/jackyleefu/k8s-ubuntu-setup/master/setup.sh)"