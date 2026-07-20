ZSH_THEME="fwalch"
HISTFILE=~/places/.zsh_history
HISTFILESIZE=1000000000
HISTSIZE=1000000000

source ~/.local/opt/ohmyzsh/oh-my-zsh.sh

export PATH="$HOME/.local/bin/:$HOME/.local/share/nvim/mason/bin/:$PATH"
export EDITOR="nvim"
export GNUPGHOME="~/places/gpg"
export AWS_CONFIG_FILE="~/places/.aws_credentials"
export FZF_DEFAULT_OPTS='--reverse'

alias v="nvim"
alias s="ssh"
alias vv="test -d .venv && source .venv/bin/activate || deactivate"
alias py="python3"
alias cl="claude.sh"
alias oc="opencode.sh"
alias kl="kubectl"

# batcat for help and man pages
alias -g -- -h='-h 2>&1 | batcat --language=help --style=plain'
alias -g -- --help='--help 2>&1 | batcat --language=help --style=plain'
export MANPAGER="batcat -plman"

source <(kubectl completion zsh)
source <(fzf --zsh)
