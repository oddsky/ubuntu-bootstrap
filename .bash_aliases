export PS1=' \[\e[34;1m\]\W\[\e[0m\] ❱ '
export EDITOR="/usr/bin/nvim"
export PATH="$HOME/.local/share/nvim/mason/bin/:$PATH"
export GNUPGHOME="~/places/gpg"
export AWS_CONFIG_FILE="~/places/.aws_credentials"
export FZF_DEFAULT_OPTS='--reverse --bind=alt-k:up,alt-j:down --style=minimal --color=bw'

if [ ! -f /tmp/comp ]; then
    kubectl completion bash > /tmp/comp
    fzf --bash >> /tmp/comp
fi
source /tmp/comp

alias v='nvim'

git_clean() {
    # master или main
    b=$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's@^origin/@@')
    if [ -z "$b" ]; then
        if git branch --list main >/dev/null 2>&1; then
            b=main
        else
            b=master
        fi
    fi
    git checkout "$b" && git pull
    git branch -vv | awk '/: gone]/{print $1}' | xargs git branch -D
}

vv() {
    MYVENV=./.venv
    # when you cd into a folder that contains $MYVENV
    [[ -d $MYVENV ]] && source $MYVENV/bin/activate > /dev/null 2>&1
    # when you cd into a folder that doesn't
    [[ ! -d $MYVENV ]] && deactivate > /dev/null 2>&1
}
