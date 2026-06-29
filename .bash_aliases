PS1='\[\e[90m\]($?)\[\e[0m\] \[\e[94m\]\W\[\e[0m\]\$ '
FZF_DEFAULT_OPTS='--reverse --bind=alt-k:up,alt-j:down --wrap'

export PATH="~/.local/bin/:~/.local/share/nvim/mason/bin/:$PATH"
export EDITOR="nvim"
export GNUPGHOME="~/places/gpg"
export AWS_CONFIG_FILE="~/places/.aws_credentials"

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
        -w "$(pwd)" \
        -v "$(pwd):$(pwd):rw" \
        -v "$HOME/places/claude:/claude:rw" \
        -v "$HOME/.local/share/uv:$HOME/.local/share/uv" \
        localhost/claude:latest
}

git_clean() {
    BRANCH=$(git symbolic-ref --short refs/remotes/origin/HEAD | sed 's|^origin/||')
    git checkout "$BRANCH" && git pull && git fetch --prune
    LANG=en_US.UTF-8 git branch -vv | awk '/: gone]/{print $1}' | xargs git branch -D
}
