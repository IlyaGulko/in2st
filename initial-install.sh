#! /usr/bin/env bash

usage () {
    echo "Usage"
}
pip3 () {
    echo "=== Installing Python3 and Pip3.."
    apt-get install python3 -y
    apt-get install pip3 -y
}

docker () {
    echo "=== Installing Docker.."
    apt-get remove docker docker-engine docker.io containerd runc
    apt-get update
    apt-get install \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        software-properties-common -y
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"
    apt-get update
    apt-get install docker-ce docker-ce-cli containerd.io -y
    echo "=== Adding $USER to docker group"
    usermod -aG docker $USER
    docker --version
    echo "=== Re-login to use Docker with your account"
}

ansible () {
    echo "=== Installing Ansible.."
    apt-get install software-properties-common
    apt-add-repository --yes --update ppa:ansible/ansible
    apt-get install ansible -y
    ansible --version
}

terraform () {
    echo "=== Installing Terraform.."
    apt-get install unzip wget -y
    wget https://releases.hashicorp.com/terraform/0.11.13/terraform_0.11.13_linux_amd64.zip
    unzip terraform_0.11.13_linux_amd64.zip
    mv terraform /usr/local/bin/
    terraform --version
}

[ $# -eq 0 ] && usage && exit 0
arguments="$@"
for arg in arguments; do
    case $arg in
        pip|pip3)
            pip3
            ;;
        docker)
            docker
            ;;
        ansible)
            ansible
            ;;
        terraform)
            terraform
            ;;
        -h|--help|help)
            usage
            ;;
    esac
done