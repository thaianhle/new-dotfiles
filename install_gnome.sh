#!/bin/bash

ZSH_CUSTOM=$HOME/.oh-my-zsh/custom
install() {
    echo "installing gnome desktop"
    sudo apt-get update -y
    sudo apt-get install -y \
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
	gnome-tweaks \
        gnome-shell-extensions \
        gnome-system-monitor \
        gnome-terminal \
        gnome-tweaks \
        nautilus \
        network-manager-gnome \
        network-manager-openvpn \
        network-manager-openvpn-gnome \
        wl-clipboard \
        xsel

    echo "installing oh-my-zsh and plugins"
    install_oh_my_zsh

    echo "start copying config"
    copy_config

    echo "installing zsh plugin"
    zsh_plugin

    echo "change default shell"
    sudo chsh -s $(which zsh) $USER
}

install_oh_my_zsh() {
echo "installing oh-my-zsh"
NO_INTERACTIVE=true sh -c "$(curl -fsSL https://raw.githubusercontent.com/subtlepseudonym/oh-my-zsh/feature/install-noninteractive/tools/install.sh)"
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

zsh_plugin() {
echo "installing zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions

echo "installing zsh-syntax-highlighting"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

echo "installing zsh-fast-syntax-highlighting"
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git $ZSH_CUSTOM/plugins/fast-syntax-highlighting

echo "installing zsh-autocomplete"
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete
}

install_alacritty() {
sudo apt-get remove --purge alacritty -y
sudo apt install cmake pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3
git clone https://github.com/alacritty/alacritty.git
cd alacritty
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
rustup override set stable
rustup update stable

cargo build --release
# Force support for only Wayland
#cargo build --release --no-default-features --features=wayland

# Force support for only X11
cargo build --release --no-default-features --features=x11

# post install
sudo cp target/release/alacritty /usr/local/bin # or anywhere else in $PATH
sudo cp extra/logo/alacritty-term.svg /usr/share/pixmaps/Alacritty.svg
sudo desktop-file-install extra/linux/Alacritty.desktop
sudo update-desktop-database
}
$@
