#!/bin/bash -xe

find -type d ! -path '*.git/*' | xargs --verbose -I{} mkdir -p ~/{}
find -type f ! -path '*.git/*' | xargs --verbose -I{} ln -sfr {} ~/{}

dconf write "/org/gnome/desktop/input-sources/xkb-options" "['caps:swapescape']"
dconf write "/org/gnome/desktop/wm/keybindings/switch-input-source" "['<Alt>Shift_L']"
dconf write "/org/gnome/desktop/wm/keybindings/close" "['<Shift><Super>q']"
dconf write "/org/gnome/settings-daemon/plugins/media-keys/calculator" "['<Super>c']"
dconf write "/org/gnome/settings-daemon/plugins/media-keys/home" "['<Super>e']"
dconf write "/org/gnome/shell/extensions/dash-to-dock/click-action" "'minimize'"

sudo apt install -y evolution-ews wl-clipboard keepassxc podman-docker golang-go \
    ripgrep fzf npm curl tmux skopeo ansible sqlite3 gnome-shell-extensions \
    network-manager-openconnect-gnome gnome-browser-connector python3-venv

sudo snap install pinta telegram-desktop
# sudo snap install --classic pycharm-community

NAME="arch-tools"
PACKAGE="kubectl helm helmfile sops k9s dive uv"
podman container exists $NAME && podman start -ai $NAME \
    || podman run --name $NAME archlinux:latest pacman -Sy --noconfirm --needed -dd $PACKAGE
tr ' ' '\n' <<<$PACKAGE | xargs --verbose -I{} podman cp $NAME:/usr/bin/{} ~/.local/bin/{}

uv tool install --force tldr
uv tool install --force --python python3.12 aider-chat

helm plugin install https://github.com/databus23/helm-diff || true

if [ ! -f ~/.fonts/README.md ]; then
    URL="https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip"
    wget "$URL" -O /tmp/font.zip
    unzip /tmp/font.zip -d ~/.fonts
fi

if [ ! -f /usr/bin/ghostty ]; then
    URL="https://github.com/mkasberg/ghostty-ubuntu/releases/download/1.2.3-0-ppa1/ghostty_1.2.3-0.ppa1_amd64_25.10.deb"
    wget "$URL" -O /tmp/ghostty_1.2.3-0.ppa1_amd64_25.10.deb
    sudo apt install /tmp/ghostty_1.2.3-0.ppa1_amd64_25.10.deb
fi

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
fi
