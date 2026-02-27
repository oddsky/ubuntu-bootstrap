#!/bin/bash

export FZF_DEFAULT_OPTS='--bind=alt-k:up,alt-j:down --reverse --style=minimal --tmux 80,10'

RESULT=$({
        tmux list-sessions -F '#{?session_attached,❱ #{session_name},}' | sed '/^$/d'
        tmux list-sessions -F '#{?session_attached,,❱ #{session_name}}' | sed '/^$/d'
        find \
            $HOME \
            $HOME/.config \
            $HOME/places/git/personal \
            $HOME/places/git/work \
            $HOME/places/git/work/launchpad \
            -maxdepth 1 -type d 2> /dev/null
} | fzf)

if [[ $RESULT = "" ]]; then
    exit
elif [[ $RESULT == "/"* ]]; then
    SEL=$(basename "$RESULT" | tr "[:upper:]:. " "[:lower:]---")
    tmux has-session -t "$SEL" 2>/dev/null || tmux new-session -d -s "$SEL" -c "$RESULT"
else
    SEL=$(cut -d' ' -f 2 <<< $RESULT)
fi

tmux switch-client -t "$SEL"
