#! /usr/bin/env bash

usage () {
    echo "
Usage: $0 [-h|--help] [string] -- install programs and apply configurations
    
    git                 install git
    python|pip|pip3     install latest python3 and pip3 
    docker              install containerd, docker and add user to docker group
    ansible             install ansible 
    terraform           install terraform
    golang              install golang and configure its environment
    packer              install packer
    vim|vimrc           download vim configuration
    install-everything  install all programs and configurations

    installed           show what applications have been already installed
    -h|--help|help      show this message
    "
}


install_git () {
    echo "=== Installing Git.."
    sudo apt-get update
    sudo apt-get install git-core -y
    git --version \
        && echo "=== Git has been successfully installed" && sleep 1
}

install_pip3 () {
    echo "=== Installing Python3 and Pip3.."
    sudo apt-get install python3 -y
    sudo apt-get install python3-pip -y
    pip3 --version \
        && echo "=== Pip3 has been successfully installed" && sleep 1
}

install_docker () {
    echo "=== Installing Docker.."
    sudo apt-get update
    sudo apt-get install \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        software-properties-common -y
    sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo add-apt-repository \
        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) \
        stable"
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io -y
    echo "=== Adding $USER to docker group"
    sudo usermod -aG docker "$USER"
    sudo docker --version
    echo "=== Re-login to use Docker with user $USER without sudo"
}

install_ansible () {
    echo "=== Installing Ansible.."
    sudo apt-get install software-properties-common
    sudo apt-add-repository --yes --update ppa:ansible/ansible
    sudo apt-get install ansible -y
    ansible --version \
        && echo "=== Ansible has been successfully installed" && sleep 1
}

install_terraform () {
    local TERRAFORM_VERSION="0.11.13"
    echo "=== Installing Terraform $TERRAFORM_VERSION.."
    sudo apt-get install unzip -y
    wget -c https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_amd64.zip
    unzip terraform_${TERRAFORM_VERSION}_linux_amd64.zip
    sudo rm -rf /usr/local/bin/terraform
    sudo mv terraform /usr/local/bin/
    terraform --version \
        && echo "=== Terraform has been successfully installed" && sleep 1
}

install_golang () {
    local GO_VERSION="1.12.5"
    local PROJECT_DIR="go"
    echo "=== Installing Golang ${GO_VERSION}.."
    echo "!!! To complete golang installation you need to run this command: 'source sourcefile'"
    sudo apt-get update
    wget -c https://dl.google.com/go/go${GO_VERSION}.linux-amd64.tar.gz
    tar -xf go${GO_VERSION}.linux-amd64.tar.gz
    sudo rm -rf /usr/local/go
    sudo mv -f go /usr/local/
    GOROOT=/usr/local/go
    GOPATH=$HOME/$PROJECT_DIR
    PATH=$PATH:$GOPATH/bin:$GOROOT/bin
    :>sourcefile
    echo "export GOROOT=/usr/local/$PROJECT_DIR">>sourcefile
    echo "export GOPATH=$HOME/$PROJECT_DIR">>sourcefile
    echo "export PATH=$PATH:$GOPATH/bin:$GOROOT/bin">>sourcefile
    echo "=== To complete golang installation you need to run this command: 'source sourcefile'"
}

install_packer () {
    [ ! go version > /dev/null 2>&1 ] \
        && install_golang \
        && echo "Run 'source sourcefile' and start installing again" \
        && exit 0
    echo "=== Installing Packer.."
    mkdir -p $(go env GOPATH)/src/github.com/hashicorp && cd $_
    git clone https://github.com/hashicorp/packer.git
    cd packer
    sudo apt-get install build-essential -y
    make dev
    packer --version \
        && echo "=== Packer has been successfully installed" && sleep 1
}

install_vim () {
    local VIMRC_LOCATION="https://gist.githubusercontent.com/IlyaGulko/0c10b8d6cebb286daf4359b04439514e/raw/83b6651df7b7cbefda36938c217e70e3fd3b3588/vimrc"
    echo "=== Updating /etc/vim/vimrc"
    sudo apt-get install vim -y
    sudo wget -O /etc/vim/vimrc $VIMRC_LOCATION \
        && echo "=== Vimrc has been changed" && sleep 1
}

installed () {
    echo "=== Checking what applications have been already installed"
}

# #################### MAIN ####################

[ $# -eq 0 ] && usage && exit 0

for arg in "$@"; do
    case $arg in
        git)
            install_git
            ;;
        python|pip|pip3)
            install_pip3
            ;;
        docker)
            install_docker
            ;;
        ansible)
            install_ansible
            ;;
        terraform)
            install_terraform
            ;;
        golang)
            install_golang
            ;;
        packer)
            install_packer
            ;;
        vim|vimrc)
            install_vim
            ;;
        installed)
            installed
            ;;
        install-everything)
            install_git 
            install_pip3
            install_docker
            install_ansible
            install_terraform
            install_packer
            install_vim
            ;;
        -h|--help|help)
            usage
            ;;
    esac
done