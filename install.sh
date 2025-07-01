#!/bin/bash
# File: install.sh

ZSH_CUSTOM=$HOME/.oh-my-zsh/custom
INSTANCE_NAME="centos-vm"
ZONE="asia-southeast1-b"

# Function to setup base packages on server
setup_base() {
    sudo dnf install epel-release -y
    sudo dnf install unzip htop emacs -y
    sudo dnf groupinstall "Development Tools" -y
    sudo dnf install python3-devel -y
}

setup_aws() {
    echo "Installing AWS CLI"
    sudo dnf install unzip -y
    curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
    unzip awscliv2.zip
    sudo ./aws/install
    echo "Done setting up AWS CLI"
}

setup_docker() {
    echo "Installing Docker"
    sudo dnf -y install dnf-plugins-core
    sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
    sudo dnf check-update -y
    sudo dnf install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin -y
    sudo groupadd docker
    sudo usermod -aG docker $USER
    newgrp docker
    sudo systemctl restart docker.service
    echo "Done setting up Docker"
}

setup_tailscale() {
    echo "Installing Tailscale private tunnel"
    curl -fsSL https://tailscale.com/install.sh | sh
    sudo tailscale up
}

setup_zsh() {
    echo "Cleanup and reinstall Oh-My-Zsh"
    rm -rf $HOME/.oh-my-zsh
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    echo "Copy .zshrc"
    cp ~/new-dotfiles/home/.zshrc ~/.zshrc
    echo "Change shell for $USER to zsh"
    sudo usermod -s /bin/zsh $USER
    echo "Installing zsh-autosuggestions"
    git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
    echo "Installing zsh-syntax-highlighting"
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
    echo "Installing zsh-fast-syntax-highlighting"
    git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git $ZSH_CUSTOM/plugins/fast-syntax-highlighting
    echo "Installing zsh-autocomplete"
    git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete
}

setup_windsurf() {
    echo "Copy windsurf extension"
    cp -r ~/new-dotfiles/.windsurf $HOME/
}

setup_k8s() {
    echo "Installing kubectl"
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
    chmod +x kubectl
    sudo mv kubectl /usr/local/bin/kubectl
}

setup_server() {
    setup_base
    setup_aws
    setup_docker
    setup_tailscale
    setup_zsh
    setup_windsurf
    setup_k8s
}


# Local laptop setup: Generate SSH key, update metadata, create instance, update .aws/config, rsync, and setup server
local_setup() {
    echo "Running local setup..."

    ./boot_instance.sh
    # Step 1: Generate SSH key if it doesn't exist
    SSH_KEY_PATH="$HOME/.ssh/gcp_key"
    if [ ! -f "$SSH_KEY_PATH" ]; then
        echo "Generating SSH key at $SSH_KEY_PATH"
        ssh-keygen -t rsa -f "$SSH_KEY_PATH"
        chmod 400 "$SSH_KEY_PATH"
    else
        echo "SSH key already exists at $SSH_KEY_PATH"
    fi

    TMP_SSH_KEY="$SSH_KEY_PATH.prefixed.pub"
    echo "$USER:$(cat "$SSH_KEY_PATH.pub")" > "$TMP_SSH_KEY"
    # Step 2: Add SSH public key to GCP project metadata
    echo "Adding SSH public key to GCP project metadata"
    gcloud compute instances add-metadata $INSTANCE_NAME --zone $ZONE --metadata-from-file ssh-keys="$TMP_SSH_KEY"
    rm -rf $TMP_SSH_KEY

    # Step 3: Wait for instance to be ready and get external IP
    echo "Waiting for instance to be ready..."
    sleep 30 # Wait for instance to start
    VM_EXTERNAL_IP=$(gcloud compute instances list --zones $ZONE | grep $INSTANCE_NAME | awk '{print $6}')
    if [ -z "$VM_EXTERNAL_IP" ]; then
        echo "Error: Could not retrieve VM external IP. Check if instance was created successfully."
        exit 1
    fi
    echo "VM External IP: $VM_EXTERNAL_IP"

    # Step 4: Ensure Tailscale is up
    echo "Starting Tailscale on local laptop"
    sudo tailscale up
    # Get Tailscale IP
    TAILSCALE_IP=$(tailscale ip -4)
    if [ -z "$TAILSCALE_IP" ]; then
        echo "Error: Could not get Tailscale IP. Ensure Tailscale is running."
        exit 1
    fi
    echo "Tailscale IP: $TAILSCALE_IP"

    # Step 5: Update .aws/config with Tailscale IP
    sed -i "s|http://localhost:8080|http://$TAILSCALE_IP:8080|g" ~/new-dotfiles/.aws/config

    echo "Updated .aws/config with Tailscale IP: $TAILSCALE_IP"

    # Step 6: Rsync to server
    echo "Syncing new-dotfiles to server $VM_EXTERNAL_IP"
    rsync -azP -e "ssh -i $SSH_KEY_PATH" ./new-dotfiles $USER@$VM_EXTERNAL_IP:~/new-dotfiles

    # Step 7: SSH and run setup on server
    echo "Boostrap aws_proxy"
    rm -rf aws_proxy.log
    pid=ps aux | grep aws_proxy.py | grep -v grep | awk '{print $2}'
    if [ -n "$pid" ]; then
        echo "Killing existing aws_proxy process"
        kill -9 $pid
    fi

    echo "RUN nohup python3 aws_proxy.py > aws_proxy.log 2>&1 &"

    nohup python3 aws_proxy.py > aws_proxy.log &

    echo "check curl http://localhost:8080/aws-credentials"
    curl http://localhost:8080/$TAILSCALE_IP:8080/aws-credentials

    echo "please ssh into server and run: >>>"
    echo "cd new-dotfiles && ./install.sh setup_server"
}

# Execute function based on argument
$@
