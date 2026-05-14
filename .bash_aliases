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

aider() {
    podman build -f ~/.images/aider/Dockerfile -t localhost/aider:latest .
    podman run --rm -it \
        --env AIDER_MULTILINE=true \
        --env AIDER_OPENAI_API_KEY=$(cat ~/places/.proxyapi_key) \
        --env AIDER_OPENAI_API_BASE="https://openai.api.proxyapi.ru/v1" \
        --env AIDER_MODEL="openai/gemini/gemini-3-flash-preview" \
        --env AIDER_WEAK_MODEL="openai/gemini/gemini-2.5-flash-lite" \
        --env AIDER_SHOW_MODEL_WARNINGS=false \
        --env AIDER_CHECK_MODEL_ACCEPTS_SETTINGS=false \
        --env AIDER_EDIT_FORMAT="diff-fenced" \
        --env AIDER_MAP_TOKENS=1024 \
        --env OPENAI_API_BASE="https://openai.api.proxyapi.ru/v1" \
        --env AIDER_GITIGNORE=false \
        --env AIDER_AUTO_COMMITS=false \
        --env AIDER_AUTO_LINT=false \
        --env AIDER_ANALYTICS=false \
        --env AIDER_CHECK_UPDATE=false \
        --env AIDER_WATCH_FILES=true \
        --env AIDER_DARK_MODE=true \
        --env AIDER_SHOW_RELEASE_NOTES=false \
        --env AIDER_ANALYTICS=false \
        --network host \
        -v "$(pwd):/workspace:rw" \
        localhost/aider:latest
}

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
