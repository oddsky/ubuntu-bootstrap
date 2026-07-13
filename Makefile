all: symlinks dconf pkg snap arch helm fonts ktalk nvim

symlinks:
	find -type d ! -path '*.git/*' | xargs -I{} mkdir -p ~/{}
	find -type f ! -path '*.git/*' | xargs -I{} ln -sfr {} ~/{}

dconf:
	dconf write /org/gnome/desktop/input-sources/xkb-options "['caps:swapescape']"
	dconf write /org/gnome/desktop/wm/keybindings/close "['<Shift><Super>q']"
	dconf write /org/gnome/desktop/wm/keybindings/switch-input-source "['<Alt>Shift_L']"
	dconf write /org/gnome/settings-daemon/plugins/media-keys/calculator "['<Super>c']"
	dconf write /org/gnome/settings-daemon/plugins/media-keys/home "['<Super>e']"

pkg:
	sudo apt install -y alacritty tmux evolution-ews keepassxc podman-docker wl-clipboard \
		fzf ripgrep npm curl skopeo ansible golang-go openjdk-21-jdk maven python3-venv \
		network-manager-openconnect-gnome gnome-browser-connector
	sudo snap install pinta telegram-desktop

helm:
	helm plugin install --verify=false https://github.com/databus23/helm-diff || true

ARCH_PKGS := kubectl helm helmfile sops k9s dive uv
arch:
	podman run --replace --name arch -v "$$PWD/mirrorlist:/etc/pacman.d/mirrorlist" archlinux \
		pacman -Sy --noconfirm --needed -dd $(ARCH_PKGS)
	$(foreach p, $(ARCH_PKGS), podman cp arch:/usr/bin/$(p) ~/.local/bin/$(p);)

FONT_URL := https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip
fonts:
	wget $(FONT_URL) -O /tmp/font.zip && unzip -o /tmp/font.zip -d ~/.fonts

KTALK_URL := https://st.ktalk.host/data/ktalk-app/linux/ktalk3.3.0amd64.deb
ktalk:
	wget $(KTALK_URL) -O /tmp/ktalk.deb && sudo apt install -y /tmp/ktalk.deb

NVIM_URL := https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz
nvim:
	wget $(NVIM_URL) -O /tmp/nvim.tar.gz \
		&& tar xzf /tmp/nvim.tar.gz -C ~/.local/opt/nvim/ \
		&& ln -sfr ~/.local/opt/nvim/nvim-linux-x86_64/bin/nvim ~/.local/bin/nvim
