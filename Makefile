APT_PKGS := alacritty tmux evolution-ews keepassxc podman-docker wl-clipboard fzf npm \
			ripgrep curl skopeo ansible golang-go openjdk-21-jdk maven python3-venv \
			zsh network-manager-openconnect-gnome gnome-browser-connector
SNAP_PKGS := pinta telegram-desktop
ARCH_PKGS := kubectl helm helmfile sops k9s dive uv
UV_PKGS := tldr beautysh ruff
FONT_URL := https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip
KTALK_URL := https://st.ktalk.host/data/ktalk-app/linux/ktalk3.3.0amd64.deb
NVIM_URL := https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz

all: sync dconf apt snap arch uv helm zsh fonts ktalk nvim
sync:
	find -type d ! -path '*.git/*' | xargs -I{} mkdir -p ~/{}
	find -type f ! -path '*.git/*' | xargs -I{} ln -sfr {} ~/{}
dconf:
	dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:swapescape']"
	dconf write /org/gnome/desktop/wm/keybindings/close "['<Shift><Super>q']"
	dconf write /org/gnome/desktop/wm/keybindings/switch-input-source "['<Alt>Shift_L']"
	dconf write /org/gnome/settings-daemon/plugins/media-keys/calculator "['<Super>c']"
	dconf write /org/gnome/settings-daemon/plugins/media-keys/home "['<Super>e']"
apt:
	sudo apt install -y $(APT_PKGS)
snap:
	sudo snap install $(SNAP_PKGS)
arch:
	podman run --replace --name arch -v "$$PWD/mirrorlist:/etc/pacman.d/mirrorlist" archlinux \
		pacman -Sy --noconfirm --needed -dd $(ARCH_PKGS)
	$(foreach p, $(ARCH_PKGS), podman cp arch:/usr/bin/$(p) ~/.local/bin/$(p);)
uv:
	$(foreach p, $(UV_PKGS), uv tool install $(p);)
helm:
	helm plugin install --verify=false https://github.com/databus23/helm-diff || true
zsh:
	test -d ~/.local/opt/ohmyzsh/ || git clone https://github.com/ohmyzsh/ohmyzsh/ ~/.local/opt/ohmyzsh/
fonts:
	wget $(FONT_URL) -O /tmp/font.zip && unzip -o /tmp/font.zip -d ~/.fonts
ktalk:
	wget $(KTALK_URL) -O /tmp/ktalk.deb && sudo apt install -y /tmp/ktalk.deb
nvim:
	wget $(NVIM_URL) -O /tmp/nvim.tar.gz && tar xzf /tmp/nvim.tar.gz -C ~/.local/opt/nvim/ \
		&& ln -sfr ~/.local/opt/nvim/nvim-linux-x86_64/bin/nvim ~/.local/bin/nvim
