#!/bin/bash

if [[ -n "$TMUX" ]]; then
    exit 0
fi

if ! tmux list-sessions &>/dev/null; then
    exec tmux
fi

SESSION_ALL=$(tmux list-sessions -F '#{session_name}:#{session_attached}')
SESSION_TARGET=""

# Prefer an unattached session (not open in another terminal)
while IFS=: read -r name attached; do
    if [[ "$attached" == "0" ]]; then
        SESSION_TARGET="$name"
        break
    fi
done <<< "$SESSION_ALL"

# Fallback to the first session if all sessions are attached
if [[ -z "$SESSION_TARGET" ]]; then
    SESSION_TARGET=$(echo "$SESSION_ALL" | head -n1 | cut -d: -f1)
fi

if [[ -n "$SESSION_TARGET" ]]; then
    exec tmux attach-session -t "$SESSION_TARGET"
else
    exec tmux
fi
