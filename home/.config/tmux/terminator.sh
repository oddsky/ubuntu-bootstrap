#!/bin/bash

FZF_OPTS='--bind=alt-k:up,alt-j:down --reverse'
LIST=$(
    {
        tmux list-sessions -F '#{?session_attached,#{session_name},}' | sed '/^$/d'
        tmux list-sessions -F '#{?session_attached,,#{session_name}}' | sed '/^$/d'
        find \
            $HOME \
            $HOME/.config \
            $HOME/places/git/personal \
            $HOME/places/git/work \
            -maxdepth 1 -type d
    }
)

RESULT=$(fzf $FZF_OPTS <<<"$LIST") || exit

if [[ $RESULT == "/"* ]]; then
    SEL=$(basename "$RESULT" | tr "[:upper:]:. " "[:lower:]---")
    tmux has-session -t "$SEL" 2>/dev/null || tmux new-session -d -s "$SEL" -c "$RESULT"
else
    SEL=${RESULT}
fi

tmux switch-client -t "$SEL"
