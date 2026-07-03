PS1='\[\e[90m\]($?)\[\e[0m\] \[\e[94m\]\W\[\e[0m\]\$ '
FZF_DEFAULT_OPTS='--reverse --bind=alt-k:up,alt-j:down --wrap'

export PATH="~/.local/bin/:~/.local/share/nvim/mason/bin/:$PATH"
export EDITOR="nvim"
export GNUPGHOME="~/places/gpg"
export AWS_CONFIG_FILE="~/places/.aws_credentials"

alias v="nvim"
alias s="ssh"
alias vv="test -d .venv && source .venv/bin/activate || deactivate"
alias py="python3"
alias cl="claude.sh"
alias oc="opencode.sh"

if [ ! -f /tmp/comp ]; then
    kubectl completion bash > /tmp/comp
    fzf --bash >> /tmp/comp
fi
source /tmp/comp
