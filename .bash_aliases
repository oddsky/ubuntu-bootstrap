export PS1=' \[\e[34;1m\]\W\[\e[0m\] ❱ '
export EDITOR="nvim"
export PATH="$HOME/.local/share/nvim/mason/bin/:$PATH"
export GNUPGHOME="~/places/gpg"
export AWS_CONFIG_FILE="~/places/.aws_credentials"
export FZF_DEFAULT_OPTS='--reverse --bind=alt-k:up,alt-j:down'

alias v='nvim'
alias vv='test -d .venv && source .venv/bin/activate || deactivate'

if [ ! -f /tmp/comp ]; then
    kubectl completion bash > /tmp/comp
    fzf --bash >> /tmp/comp
fi
source /tmp/comp

git_clean() {
    BRANCH=$(git symbolic-ref --short refs/remotes/origin/HEAD | sed 's|^origin/||')
    git checkout "$BRANCH" && git pull
    git branch -vv | awk '/: gone]/{print $1}' | xargs git branch -D
}
