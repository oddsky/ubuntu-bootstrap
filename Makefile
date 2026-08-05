all: sync dconf apt snap uv k9s helm helmfile sops taplo cbfmt gofumpt stylua yamlfmt kubectl uv_pkgs helm_plugin fonts ktalk nvim

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
	sudo apt install -y \
		alacritty tmux evolution-ews keepassxc podman-docker wl-clipboard fzf npm \
		ripgrep curl skopeo ansible golang-go openjdk-21-jdk maven python3-venv \
		network-manager-openconnect-gnome gnome-browser-connector

snap:
	sudo snap install pinta telegram-desktop

uv:
	curl -fsSL https://releases.astral.sh/github/uv/releases/download/0.12.2/uv-x86_64-unknown-linux-gnu.tar.gz \
		| tar xzO uv-x86_64-unknown-linux-gnu/uv \
		> ~/.local/bin/uv
	chmod +x ~/.local/bin/uv

k9s:
	curl -fsSL https://github.com/derailed/k9s/releases/download/v0.51.0/k9s_Linux_amd64.tar.gz \
		| tar xzO k9s \
		> ~/.local/bin/k9s
	chmod +x ~/.local/bin/k9s

helm:
	curl -fsSL https://get.helm.sh/helm-v4.2.3-linux-amd64.tar.gz \
		| tar xzO linux-amd64/helm \
		> ~/.local/bin/helm
	chmod +x ~/.local/bin/helm

helmfile:
	curl -fsSL https://github.com/helmfile/helmfile/releases/download/v1.7.3/helmfile_1.7.3_linux_amd64.tar.gz \
		| tar xzO helmfile \
		> ~/.local/bin/helmfile
	chmod +x ~/.local/bin/helmfile

sops:
	curl -fsSL https://github.com/getsops/sops/releases/download/v3.13.3/sops-v3.13.3.linux.amd64 \
		> ~/.local/bin/sops
	chmod +x ~/.local/bin/sops

taplo:
	curl -fsSL https://github.com/tamasfe/taplo/releases/download/0.10.0/taplo-linux-x86_64.gz \
		| gzip -d - \
		> ~/.local/bin/taplo
	chmod +x ~/.local/bin/taplo

cbfmt:
	curl -fsSL https://github.com/lukas-reineke/cbfmt/releases/download/v0.2.0/cbfmt_linux-x86_64_v0.2.0.tar.gz \
		| tar xzO cbfmt_linux-x86_64_v0.2.0/cbfmt \
		> ~/.local/bin/cbfmt
	chmod +x ~/.local/bin/cbfmt

gofumpt:
	curl -fsSL https://github.com/mvdan/gofumpt/releases/download/v0.11.0/gofumpt_v0.11.0_linux_amd64 \
		> ~/.local/bin/gofumpt
	chmod +x ~/.local/bin/gofumpt

stylua:
	curl -fsSL https://github.com/JohnnyMorganz/StyLua/releases/download/v2.5.2/stylua-linux-x86_64.zip \
		| busybox unzip -p - \
		> ~/.local/bin/stylua
	chmod +x ~/.local/bin/stylua

yamlfmt:
	curl -fsSL https://github.com/google/yamlfmt/releases/download/v0.21.0/yamlfmt_0.21.0_Linux_x86_64.tar.gz \
		| tar xzO yamlfmt \
		> ~/.local/bin/yamlfmt
	chmod +x ~/.local/bin/yamlfmt

kubectl:
	curl -fsSL https://dl.k8s.io/release/v1.36.3/bin/linux/amd64/kubectl \
		> ~/.local/bin/kubectl
	chmod +x ~/.local/bin/yamlfmt

UV_PKGS := tldr beautysh ruff pyright
uv_pkgs:
	$(foreach p, $(UV_PKGS), uv tool install $(p);)

helm_plugin:
	helm plugin install --verify=false https://github.com/databus23/helm-diff || true

fonts:
	wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.4.0/JetBrainsMono.zip \
		-O /tmp/font.zip
	unzip -o /tmp/font.zip -d ~/.fonts

ktalk:
	wget https://st.ktalk.host/data/ktalk-app/linux/ktalk3.3.0amd64.deb \
		-O /tmp/ktalk.deb
	sudo apt install -y /tmp/ktalk.deb

nvim:
	wget https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz \
		-O /tmp/nvim.tar.gz
	tar xzf /tmp/nvim.tar.gz -C ~/.local/opt/nvim/
	ln -sfr ~/.local/opt/nvim/nvim-linux-x86_64/bin/nvim ~/.local/bin/nvim
