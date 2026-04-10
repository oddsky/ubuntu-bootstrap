#!/bin/bash -xe

find -type d ! -path '*.git/*' | xargs --verbose -I{} mkdir -p ~/{}
find -type f ! -path '*.git/*' | xargs --verbose -I{} ln -sfr {} ~/{}

dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:swapescape']"
dconf write /org/gnome/desktop/wm/keybindings/close "['<Shift><Super>q']"
dconf write /org/gnome/desktop/wm/keybindings/switch-input-source "['<Alt>Shift_L']"
dconf write /org/gnome/settings-daemon/plugins/media-keys/calculator "['<Super>c']"
dconf write /org/gnome/settings-daemon/plugins/media-keys/home "['<Super>e']"

sudo apt install -y \
    alacritty evolution-ews keepassxc showtime podman-docker wl-clipboard fzf awscli \
    ripgrep npm curl tmux skopeo ansible golang-go openjdk-21-jdk maven python3-venv \
    network-manager-openconnect-gnome gnome-browser-connector

sudo snap install pinta telegram-desktop

pkgs="kubectl helm helmfile sops k9s dive uv"
podman run --replace --name arch -v "$PWD/mirrorlist:/etc/pacman.d/mirrorlist" archlinux \
    pacman -Sy --noconfirm --needed -dd $pkgs
echo $pkgs | tr ' ' '\n' | xargs --verbose -I{} podman cp archtool:/usr/bin/{} ~/.local/bin/{}

helm plugin install --verify=false https://github.com/databus23/helm-diff || true

URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip"
wget "$URL" -O /tmp/font.zip
unzip /tmp/font.zip -d ~/.fonts

URL="https://st.ktalk.host/data/ktalk-app/linux/ktalk3.3.0amd64.deb"
wget "$URL" -O /tmp/ktalk.deb
sudo apt install -y /tmp/ktalk.deb

URL="https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz"
wget "$URL" -O /tmp/nvim.tar.gz
tar xzf /tmp/nvim.tar.gz -C ~/.local/opt/nvim/
ln -sfr ~/.local/opt/nvim/nvim-linux-x86_64/bin/nvim ~/.local/bin/nvim
