PS1='\[\e[90m\]($?)\[\e[0m\] \[\e[94m\]\W\[\e[0m\]\$ '

export PATH="$HOME/.local/share/nvim/mason/bin/:$HOME/.local/bin/:$PATH"
export EDITOR="nvim"
export GNUPGHOME="~/places/gpg"
export AWS_CONFIG_FILE="~/places/.aws_credentials"
export FZF_DEFAULT_OPTS='--reverse --bind=alt-k:up,alt-j:down'

export AIDER_DARK_MODE=true
export AIDER_OPENAI_API_KEY=$(cat ~/places/.proxyapi_key)
export AIDER_OPENAI_API_BASE="https://openai.api.proxyapi.ru/v1"
export AIDER_MODEL="openai/gemini/gemini-3-flash-preview"
export AIDER_WEAK_MODEL="openai/gemini/gemini-2.5-flash-lite"
export AIDER_SHOW_MODEL_WARNINGS=false
export AIDER_CHECK_MODEL_ACCEPTS_SETTINGS=false
export AIDER_EDIT_FORMAT="diff-fenced"
export AIDER_MAP_TOKENS=1024
export OPENAI_API_BASE="https://openai.api.proxyapi.ru/v1"
export AIDER_GITIGNORE=false
export AIDER_AUTO_COMMITS=false
export AIDER_AUTO_LINT=false
export AIDER_ANALYTICS=false
export AIDER_CHECK_UPDATE=false
export AIDER_WATCH_FILES=true

alias v='nvim'
alias s='ssh'
alias vv='test -d .venv && source .venv/bin/activate || deactivate'
alias py='python3'

if [ ! -f /tmp/comp ]; then
    kubectl completion bash > /tmp/comp
    fzf --bash >> /tmp/comp
fi
source /tmp/comp

git_clean() {
    BRANCH=$(git symbolic-ref --short refs/remotes/origin/HEAD | sed 's|^origin/||')
    git checkout "$BRANCH" && git pull
    LANG=en_US.UTF-8 git branch -vv | awk '/: gone]/{print $1}' | xargs git branch -D
}

osc7_cwd() {
    local strlen=${#PWD}
    local encoded=""
    local pos c o
    for (( pos=0; pos<strlen; pos++ )); do
        c=${PWD:$pos:1}
        case "$c" in
            [-/:_.!\'\(\)~[:alnum:]] ) o="${c}" ;;
            * ) printf -v o '%%%02X' "'${c}" ;;
        esac
        encoded+="${o}"
    done
    printf '\e]7;file://%s%s\e\\' "${HOSTNAME}" "${encoded}"
}
PROMPT_COMMAND=${PROMPT_COMMAND:+${PROMPT_COMMAND%;}; }osc7_cwd
