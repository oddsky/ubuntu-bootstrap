PS1='\[\e[90m\]($?)\[\e[0m\] \[\e[94m\]\W\[\e[0m\]\$ '
export PATH="$HOME/.local/bin/:$HOME/.local/share/nvim/mason/bin/:$PATH"
export EDITOR="nvim"
export GNUPGHOME="~/places/gpg"
export AWS_CONFIG_FILE="~/places/.aws_credentials"
export FZF_DEFAULT_OPTS="--reverse"
export BAT_THEME="base16"
export MANPAGER="batcat -lman -sp"

alias cat="batcat"
alias v="nvim"
alias s="ssh"
alias vv="test -d .venv && source .venv/bin/activate || deactivate"
alias py="python3"
alias cl="claude.sh"
alias oc="opencode.sh"
alias kl="kubectl"
alias cp="wl-copy"
alias tmp="cd ~/temp"

source <(kubectl completion bash)
source <(fzf --bash)
