#!/bin/bash
set -e

install() {
    echo "installing gnome desktop"
    sudo apt update -y
    sudo apt install -y \
        zsh \
        zsh-autosuggestions \
        zsh-syntax-highlighting \
        emacs \
        meson \
        ninja-build \
        cmake \
        cmake-data \
        pkg-config \
        fzf \
        alacritty \
        eog \
        evince \
        gnome-calculator \
        gnome-disk-utility \
        gnome-screenshot \
        gnome-session \
        gnome-shell-extensions \
        gnome-system-monitor \
        gnome-terminal \
        gnome-tweaks \
        nautilus \
        nautilus-wipe \
        network-manager-gnome \
        network-manager-openvpn \
        network-manager-openvpn-gnome \
        wl-clipboard \
        xsel

    echo "start copying config"
    copy_config

    echo "installing oh-my-zsh and plugins"
    zsh

    echo "installing osx-font"
    osx-font
}

zsh() {
echo "installing oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo "installing zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions

echo "installing zsh-syntax-highlighting"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

echo "installing zsh-fast-syntax-highlighting"
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting

echo "installing zsh-autocomplete"
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete
}

copy_config() {
echo "copying config for .fonts, .zshrc, .icons into home folder"
cp -r home/.fonts ~/
cp -r home/.zshrc ~/
cp -r home/.icons ~/

echo "copy config alacritty, fontconfig, lxterminal, xfce4terminal into config folder"
cp -r config/alacritty ~/.config
cp -r config/fontconfig ~/.config
cp -r config/lxterminal ~/.config
cp -r config/xfce4 ~/.config
}

osx-font() {
cd ~/.fonts
git clone https://github.com/froggeboi/macfonts.git 
}

$@