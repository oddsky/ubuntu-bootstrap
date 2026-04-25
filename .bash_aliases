PS1='\[\e[90m\]($?)\[\e[0m\] \[\e[94m\]\W\[\e[0m\]\$ '

export PATH="~/.local/bin/:~/.local/share/nvim/mason/bin/:$PATH"
export EDITOR="nvim"
export GNUPGHOME="~/places/gpg"
export AWS_CONFIG_FILE="~/places/.aws_credentials"
FZF_DEFAULT_OPTS='--reverse --bind=alt-k:up,alt-j:down --wrap'

alias v='nvim'
alias s='ssh'
alias vv='test -d .venv && source .venv/bin/activate || deactivate'
alias py='python3'

if [ ! -f /tmp/comp ]; then
    kubectl completion bash > /tmp/comp
    fzf --bash >> /tmp/comp
fi
source /tmp/comp

claude() {
    podman build -f ~/.images/claude/Dockerfile -t localhost/claude:latest .
    podman run --rm -it \
        --network host \
        -v "$(pwd):/workspace:rw" \
        -v "$HOME/.claude:/claude:rw" \
        localhost/claude:latest
}

git_clean() {
    BRANCH=$(git symbolic-ref --short refs/remotes/origin/HEAD | sed 's|^origin/||')
    git checkout "$BRANCH" && git pull && git fetch --prune
    LANG=en_US.UTF-8 git branch -vv | awk '/: gone]/{print $1}' | xargs git branch -D
}
