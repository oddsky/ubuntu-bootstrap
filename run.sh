#!/bin/bash

set -xe

su - -c "apt install sudo && usermod -aG sudo rrossamakhin"

sudo apt install -y \
    sway swayidle swaylock waybar fuzzel grim kanshi mako-notifier pavucontrol \
    pulseaudio-utils wl-clipboard cliphist blueman brightnessctl slurp ansible \
    ripgrep bat evolution-ews fzf golang-go keepassxc moreutils npm pipx unzip \
    curl skopeo podman-docker podman-compose tmux wireshark htop xwayland \
    fonts-jetbrains-mono fonts-noto

sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
sudo flatpak install -y flathub org.mozilla.firefox org.telegram.desktop
pipx install tldr
systemctl --user enable --now pulseaudio.service ssh-agent.service
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

for file in $(find $PWD/home); do
    RELNAME=$(echo $file | sed "s|$PWD/home/||g")
    if [ -d $file ]; then
        mkdir -p ~/$RELNAME
    else
        ln -sf $file ~/$RELNAME
    fi
done

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
    sudo ln -sf /opt/nvim/nvim-linux-x86_64/bin/nvim /usr/bin/nvim
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

CONTAINER="arch-tools"
TOOLS="kubectl helm helmfile sops k9s dive uv yazi nnn"

if ! podman container exists $CONTAINER; then
    podman run --name $CONTAINER archlinux:latest pacman -Sy --noconfirm --needed -dd $TOOLS
else
    podman start -ai $CONTAINER
fi

for tool in $TOOLS; do
    podman cp $CONTAINER:/usr/bin/$tool ~/.bin
    sudo ln -sf ~/.bin/$tool /usr/bin/$tool
done
