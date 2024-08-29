#!/bin/bash

ZSH_CUSTOM=$HOME/.oh-my-zsh/custom

install_gnome() {
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
	exa \
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
	gnome-control-center \
	gnome-color-manager \
	gnome-settings-daemon \
	gnome-panel \
	upower \
	power-profiles-daemon \
	polkitd \
        nautilus \
        network-manager-gnome \
        network-manager-openvpn \
        network-manager-openvpn-gnome \
        wl-clipboard \
        xsel
}

install_kali() {
    echo "installing gnome desktop"
    install_gnome

    echo "start copying config"
    copy_config
    
    echo "gnome setting fonts"
    gnome_setting_font
}

install_default() {
    echo "installing gnome desktop"
    install_gnome
    
    echo "installing oh-my-zsh and plugins"
    install_oh_my_zsh

    echo "start copying config"
    copy_config
    copy_zshrc

    echo "installing zsh plugin"
    zsh_plugin

    echo "change default shell"
    sudo chsh -s $(which zsh) $USER

    echo "gnome setting fonts"
    gnome_setting_font
}


install_oh_my_zsh() {
echo "installing oh-my-zsh"
NO_INTERACTIVE=true sh -c "$(curl -fsSL https://raw.githubusercontent.com/subtlepseudonym/oh-my-zsh/feature/install-noninteractive/tools/install.sh)"
}

copy_zshrc() {
cp -r home/.zshrc ~/
}

copy_config() {
echo "copying config for .fonts, .zshrc, .icons into home folder"
cp -r home/.fonts ~/
cp -r home/.icons ~/

echo "copy config alacritty, fontconfig, lxterminal, xfce4terminal into config folder"
cp -r config/alacritty ~/.config
cp -r config/fontconfig ~/.config
cp -r config/lxterminal ~/.config
cp -r config/xfce4 ~/.config
}

gnome_setting_font() {
gsettings set org.gnome.desktop.interface font-name 'SF Pro Display Medium 12'
    
gsettings set org.gnome.desktop.interface document-font-name 'SF Pro Display Medium 12'

gsettings set org.gnome.desktop.interface monospace-font-name 'SF Pro Display Medium 12'

# font scaling factor, better set it to be the same as the GDK_DPI_SCALE
gsettings set org.gnome.desktop.interface text-scaling-factor 1.2

gsettings set org.gnome.desktop.wm.preferences titlebar-font 'SF Pro Display Medium 11'
}

zsh_plugin() {
#echo "installing zsh-autosuggestions"
#git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions
#
#echo "installing zsh-syntax-highlighting"
#git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
#
#echo "installing zsh-fast-syntax-highlighting"
#git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git $ZSH_CUSTOM/plugins/fast-syntax-highlighting

echo "installing zsh-autocomplete"
git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete
}

$@
