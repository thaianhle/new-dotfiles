#!/bin/bash

ZSH_CUSTOM=$HOME/.oh-my-zsh/custom

setup_base() {
    sudo dnf install epel-release -y
    sudo dnf install unzip htop emacs -y
    sudo dnf groupinstall "Development Tools" -y
    sudo dnf install python3-dev
}

setup_aws() {
    echo "installing aws cli"
    sudo dnf install upzip -y

    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    echo "done setup aws cli"
}

setup_docker() {
    echo "installing docker"
    sudo dnf -y install dnf-plugins-core
    sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    sudo dnf check-update -y
    sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo groupadd docker
    sudo usermod -aG docker $USER
    newgrp docker
    sudo systemctl restart docker.service
    echo "done setup docker"
}

setup_tailscale() {
    echo "installing tailscale private tunnel"
    curl -fsSL https://tailscale.com/install.sh | sh
}

setup_zsh() {
    echo "cleanup and reinstall clean oh-my-zsh"
    rm -rf $HOME/.oh-my-zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    echo "copy .zshrc"
    cp ~/new-dotfiles/home/.zshrc ~/.zshrc

    echo "change shell $USER to zsh"
    usermod -s thaianh $USER

    echo "installing zsh-autosuggestions"
    git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions

    echo "installing zsh-syntax-highlighting"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

    echo "installing zsh-fast-syntax-highlighting"
    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git $ZSH_CUSTOM/plugins/fast-syntax-highlighting

    echo "installing zsh-autocomplete"
    git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete
}

setup_windsurf() {
    echo "copy windsurf extension"
    cp -r ~/new-dotfiles/.windsurf $HOME/
}

setup_k8s() {
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/kubectl
}
setup() {
    setup_base
    setup_aws
    setup_docker
    setup_k8s
    setup_windsurf
}

$@
