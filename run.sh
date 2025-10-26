#!/bin/bash

set -x
set -a

sudo usermod -aG video $USER

sudo apt install -y alacritty ansible bat brightnessctl curl evolution-ews fuzzel \
    fzf gnome-shell-extensions golang-go grim kanshi keepassxc mako-notifier \
    moreutils network-manager-openconnect network-manager-openconnect-gnome npm \
    pavucontrol pipx podman podman-compose podman-docker postgresql-client \
    pulseaudio-utils python3-venv ripgrep skopeo slurp sshfs sway swayidle \
    swaylock tmux waybar wireshark wl-clipboard

sudo snap install pinta postman telegram-desktop
sudo snap install --classic pycharm-community

pipx install tldr

dconf write "/org/gnome/desktop/input-sources/xkb-options" "['caps:swapescape']"
dconf write "/org/gnome/desktop/interface/enable-animations" "false"
dconf write "/org/gnome/desktop/wm/keybindings/close" "['<Shift><Super>q']"
dconf write "/org/gnome/desktop/wm/keybindings/switch-input-source" "['<Alt>Shift_L']"
dconf write "/org/gnome/desktop/wm/keybindings/toggle-maximized" "['<Super>Up']"
dconf write "/org/gnome/settings-daemon/plugins/media-keys/calculator" "['<Super>c']"
dconf write "/org/gnome/settings-daemon/plugins/media-keys/home" "['<Super>e']"
dconf write "/org/gnome/shell/extensions/dash-to-dock/click-action" "'minimize'"
dconf write "/org/gnome/shell/extensions/dash-to-dock/show-trash" "false"
dconf write "/org/gnome/shell/window-switcher/app-icon-mode" "'app-icon-only'"

for file in $(find $PWD/home); do
    RELNAME=$(echo $file | sed "s|$PWD/home/||g")
    if [ -d $file ]; then
        mkdir -p ~/$RELNAME
    else
        ln -sf $file ~/$RELNAME
    fi
done

if [ ! -f /usr/bin/ktalk ]; then
    wget \
        https://st.ktalk.host/ktalk-app/linux/ktalk3.1.0amd64.deb \
        -O /tmp/ktalk.deb
    sudo apt install -y /tmp/ktalk.deb
fi

if [ ! -f ~/.fonts/README.md ]; then
    wget \
        https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip \
        -O /tmp/JetBrainsMono.zip
    unzip /tmp/JetBrainsMono.zip -d ~/.fonts
    wget \
        https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/DepartureMono.zip \
        -O /tmp/DepartureMono.zip
    unzip /tmp/DepartureMono.zip -d ~/.fonts
fi

if [ ! -d /opt/nvim ]; then
    wget \
        https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz \
        -O /tmp/nvim-linux-x86_64.tar.gz
    sudo mkdir /opt/nvim
    sudo tar xzvf /tmp/nvim-linux-x86_64.tar.gz -C /opt/nvim
    sudo ln -sf /opt/nvim/nvim-linux-x86_64/bin/nvim /usr/bin/nvim
fi

if [ ! -d /opt/pytimesched ]; then
    wget \
        https://gitlab.com/ilmenshik/pytimesched/-/jobs/3568673400/artifacts/raw/pyTimeSched-v0.6-linux.tar.gz \
        -O /tmp/pyTimeSched.tar.gz
    sudo mkdir /opt/pytimesched
    sudo tar xzvf /tmp/pyTimeSched.tar.gz -C /opt/pytimesched
    sudo chown -R $USER:$USER /opt/pytimesched
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
TOOLS="kubectl helm helmfile sops k9s dive uv"

if ! podman container exists $CONTAINER; then
    podman run --name $CONTAINER archlinux:latest pacman -Sy --noconfirm --needed -dd $TOOLS
else
    podman start -ai $CONTAINER
fi

for tool in $TOOLS; do
    podman cp $CONTAINER:/usr/bin/$tool ~/.bin
    sudo ln -sf ~/.bin/$tool /usr/bin/$tool
done
