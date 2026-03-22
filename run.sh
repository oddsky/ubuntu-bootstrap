#!/bin/bash -xe

find -type d ! -path '*.git/*' | xargs --verbose -I{} mkdir -p ~/{}
find -type f ! -path '*.git/*' | xargs --verbose -I{} ln -sfr {} ~/{}

dconf write "/org/gnome/desktop/input-sources/xkb-options" "['caps:swapescape']"
dconf write "/org/gnome/desktop/wm/keybindings/close" "['<Shift><Super>q']"
dconf write "/org/gnome/desktop/wm/keybindings/switch-input-source" "['<Alt>Shift_L']"
dconf write "/org/gnome/settings-daemon/plugins/media-keys/calculator" "['<Super>c']"
dconf write "/org/gnome/settings-daemon/plugins/media-keys/home" "['<Super>e']"

sudo apt install -y \
    alacritty evolution-ews keepassxc showtime podman-docker wl-clipboard fzf ripgrep \
    npm curl tmux skopeo ansible sqlite3 golang-go openjdk-21-jdk maven python3-venv \
    gnome-shell-extensions network-manager-openconnect-gnome gnome-browser-connector

sudo snap install pinta telegram-desktop

pkgs="kubectl helm helmfile sops k9s dive uv"
if [ ! $(podman container exists archtool) ]; then
    podman start -ai archtool
else
    podman run --name archtool -v "$PWD/mirrorlist:/etc/pacman.d/mirrorlist" archlinux:latest \
        pacman -Sy --noconfirm --needed -dd $pkgs
fi
echo $pkgs | tr ' ' '\n' | xargs --verbose -I{} podman cp archtool:/usr/bin/{} ~/.local/bin/{}


~/.local/bin/uv tool install --force tldr
~/.local/bin/uv tool install --force awscli
~/.local/bin/uv tool install --force aider-chat

helm plugin install --verify=false https://github.com/databus23/helm-diff || true

if [ ! -f ~/.fonts/ComicShannsMono-Regular.ttf ]; then
    URL="https://github.com/jesusmgg/comic-shanns-mono/releases/download/v1.3.0/comic-shanns-mono-v1.3.0.zip"
    wget "$URL" -O /tmp/comic.zip
    unzip /tmp/comic.zip -d ~/.fonts
fi

if [ ! -f /usr/bin/ktalk ]; then
    URL="https://st.ktalk.host/data/ktalk-app/linux/ktalk3.3.0amd64.deb"
    wget "$URL" -O /tmp/ktalk.deb
    sudo apt install -y /tmp/ktalk.deb
fi

if [ ! -d ~/.local/opt/nvim ]; then
    URL="https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz"
    wget "$URL" -O /tmp/nvim.tar.gz
    tar xzf /tmp/nvim.tar.gz -C ~/.local/opt/nvim/
    ln -sfr ~/.local/opt/nvim/nvim-linux-x86_64/bin/nvim ~/.local/bin/nvim
fi

if [ ! -d ~/.local/opt/pytimesched ]; then
    URL="https://gitlab.com/ilmenshik/pytimesched/-/jobs/3568673400/artifacts/raw/pyTimeSched-v0.6-linux.tar.gz"
    wget "$URL" -O /tmp/pyTimeSched.tar.gz
    tar xzf /tmp/pyTimeSched.tar.gz -C ~/.local/opt/pytimesched/
fi
