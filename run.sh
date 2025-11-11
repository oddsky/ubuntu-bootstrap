#!/bin/bash

set -xe

sudo apt install -y \
    curl alacritty wl-clipboard ripgrep evolution-ews fzf golang-go keepassxc moreutils \
    npm pipx podman-docker podman-compose tmux wireshark ansible fonts-jetbrains-mono \
    network-manager-openconnect-gnome

sudo snap install pinta telegram-desktop
sudo snap install --classic pycharm-community

pipx install tldr

dconf write "/org/gnome/desktop/input-sources/xkb-options" "['caps:swapescape']"
dconf write "/org/gnome/desktop/wm/keybindings/switch-input-source" "['<Alt>Shift_L']"
dconf write "/org/gnome/desktop/wm/keybindings/close" "['<Shift><Super>q']"
dconf write "/org/gnome/settings-daemon/plugins/media-keys/calculator" "['<Super>c']"
dconf write "/org/gnome/settings-daemon/plugins/media-keys/home" "['<Super>e']"

find -not -path '*.git/*' -type d | xargs --verbose -I{} mkdir -p ~/{}
find -not -path '*.git/*' -type f | xargs --verbose -I{} ln -sfr {} ~/{}

if [ ! -f ~/.fonts/README.md ]; then
    URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip"
    wget "$URL" -O /tmp/JetBrainsMono.zip
    unzip /tmp/JetBrainsMono.zip -d ~/.fonts

if [ ! -f /usr/bin/ktalk ]; then
    URL="https://st.ktalk.host/ktalk-app/linux/ktalk3.1.0amd64.deb"
    wget "$URL" -O /tmp/ktalk.deb
    sudo apt install -y /tmp/ktalk.deb
fi

if [ ! -d /opt/nvim ]; then
    URL="https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz"
    wget "$URL" -O /tmp/nvim.tar.gz
    sudo mkdir /opt/nvim
    sudo tar xzvf /tmp/nvim.tar.gz -C /opt/nvim
    sudo ln -sfr /opt/nvim/nvim-linux-x86_64/bin/nvim ~/.local/bin/nvim
fi

if [ ! -d /opt/pytimesched ]; then
    URL="https://gitlab.com/ilmenshik/pytimesched/-/jobs/3568673400/artifacts/raw/pyTimeSched-v0.6-linux.tar.gz"
    wget "$URL" -O /tmp/pyTimeSched.tar.gz
    sudo mkdir /opt/pytimesched
    sudo tar xzvf /tmp/pyTimeSched.tar.gz -C /opt/pytimesched
    sudo chown -R $USER:$USER /opt/pytimesched
    mkdir -p ~/.local/share/applications/
    cat << EOF | sed 's/^[[:space:]]*//' > ~/.local/share/applications/pyTimeSched.desktop
        [Desktop Entry]
        Version=1.0
        Name=pyTimeSched
        Exec=/opt/pytimesched/pyTimeSched
        Icon=/opt/pytimesched/gui/icons/icon.png
        Terminal=false
        Type=Application
EOF
fi

NAME="arch-tools"
PACKAGE="kubectl helm helmfile sops k9s dive uv skopeo"
podman container exists $NAME \
    && podman start -ai $NAME \
    || podman run --name $NAME archlinux:latest pacman -Sy --noconfirm --needed -dd $PACKAGE
tr ' ' '\n' <<<$PACKAGE | xargs --verbose -I{} podman cp $NAME:/usr/bin/{} ~/.local/bin
