#!/bin/bash -e

podman build -f ~/.images/claude.Dockerfile -t localhost/claude:latest
podman run --rm -it \
    --network host \
    -w "$PWD" \
    -v "$PWD:$PWD:rw" \
    -v "$HOME/places/claude:/claude:rw" \
    -v "$HOME/.local/share/uv:$HOME/.local/share/uv" \
    localhost/claude:latest
