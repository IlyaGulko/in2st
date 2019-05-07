#! /usr/bin/env bash

usage () {
    echo "Usage: $0 [-h|--help] [string] -- script to install some programs and apply configurations
    
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
    apt-get update
    apt-get install git-core -y
    git --version \
        && echo "=== Git has been successfully installed" && sleep 1
}

install_pip3 () {
    echo "=== Installing Python3 and Pip3.."
    apt-get install python3 -y
    apt-get install pip3 -y

}

install_docker () {
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

install_ansible () {
    echo "=== Installing Ansible.."
    apt-get install software-properties-common
    apt-add-repository --yes --update ppa:ansible/ansible
    apt-get install ansible -y
    ansible --version
}

install_terraform () {
    local TERRAFORM_VERSION="0.11.13"
    echo "=== Installing Terraform.."
    apt-get install unzip -y
    wget -c https://releases.hashicorp.com/terraform/$TERRAFORM_VERSION/terraform_$TERRAFORM_VERSION_linux_amd64.zip
    unzip terraform_$TERRAFORM_VERSION_linux_amd64.zip
    rm -rf /usr/local/bin/terraform
    mv terraform /usr/local/bin/
    terraform --version
}

install_golang () {
    local GO_VERSION="1.12.5"
    local PROJECT_DIR="go"
    echo "=== Installing Golang $GO_VERSION.."
    echo "!!! To complete golang installation you need to run this command: 'source sourcefile'"
    apt-get update
    wget -c https://dl.google.com/go/go$GO_VERSION.linux-amd64.tar.gz
    tar -xvf go$GO_VERSION.linux-amd64.tar.gz
    rm -rf /usr/local/go
    mv -f go /usr/local/
    GOROOT=/usr/local/go
    GOPATH=$HOME/$PROJECT_DIR
    PATH=$PATH:$GOPATH/bin:$GOROOT/bin
    :>sourcefile
    echo "export GOROOT=/usr/local/$PROJECT_DIR">>sourcefile
    echo "export GOPATH=$HOME/$PROJECT_DIR">>sourcefile
    echo "export PATH=$PATH:$GOPATH/bin:$GOROOT/bin">>sourcefile
    echo "=== To complete golang installation you need to run this command: 'source sourcefile'"
    # go version
}

install_packer () {
    go version > /dev/null 2>&1; [ $? != 0 ] \
        && install_golang
    echo "=== Installing Packer.."
    mkdir -p $(go env GOPATH)/src/github.com/hashicorp && cd $_
    git clone https://github.com/hashicorp/packer.git
    cd packer
    make dev
    packer --version
}

install_vim () {
    local VIMRC_LOCATION="https://gist.githubusercontent.com/IlyaGulko/0c10b8d6cebb286daf4359b04439514e/raw/83b6651df7b7cbefda36938c217e70e3fd3b3588/vimrc"
    echo "=== Updating /etc/vim/vimrc"
    apt-get install vim -y
    wget -O /etc/vim/vimrc $VIMRC_LOCATION
}

installed () {
    echo "=== Checking what applications have been already installed"
}

[ $EUID != 0 ] \
    && echo "=== Root privileges are required" \
    && return 1

[ $# -eq 0 ] \
    && usage \
    && return 0

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