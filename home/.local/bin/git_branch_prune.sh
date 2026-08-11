#!/bin/bash -e

BRANCH=$(git symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's|^origin/||')
git checkout "$BRANCH"
git branch | grep -vE "^\*?\s*(main|master)$" | xargs --no-run-if-empty git branch -D
