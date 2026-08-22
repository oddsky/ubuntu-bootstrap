#!/bin/bash -e

# read KEY; echo $KEY | gpg -e -r rossamakhin01@gmail.com --output - | base64 -w87

PROXYAPI_API_KEY_ENC="\
hF4DGNwPncbTkogSAQdArcyUTILRNc+RCqBaNEB3QRWRHyXrDPRxY1ao5dXf7l8wZ5gpLGTJv4nz54dKyVIllfR\
CGW62JzierEncjkU+6r8Ob2tHcUqzDQGEOndM5oaW0l8BzYT+BCjpDKuu59zMBO6D4ZV0TtZVFoNfiGJw9neb1c\
QryKdwGaN+maAsJ/eCsovWcEvIlNMZ7cJS7AUQGsaz8M0R8Z4SAMF0ATe636fDF+4n0gsqKOT7Q4W9gAMptA==\
"

ZAI_API_KEY_ENC="\
hF4DGNwPncbTkogSAQdAGgNvJbgbQG0KKEAiyjbdJNmTuk979zDSCbn65pPfcAIwD2pLtTnyUmBBE1s+9/Zd1eq\
ZQuUSDiuQAZlHjTwHhulMGeF1EVMTadqoW0c2utGp0l8BpVhLTdbg60STMA9vAt59nRg903PMQ7NcFxlRPi6QXm\
s51o36C5dVtodx5IhxAnLj3DYe3pcpl+vbjNpWCfpd4CPFkoDgJZrWhUQUCcc6SiLmkskFGTbtZjmEWG44Yg==\
"

CONTEXT7_API_KEY_ENC="\
hF4DGNwPncbTkogSAQdA3SjxPFc4Y3W1roURn9JPA8vIaPMBPVcUXaWFNeHZxTYwymZUsOvwNXVf3QtFbiyKR9X\
C78+iuogG1+KEgaAjKjRxxXkXYjlTTTZltLVxj5hY0mYB1N0dPBgEpBfz0kJhTub/+hrWna799Gtq3+Np4+dTlx\
Jv7TuPNb4doJi15mEJy5npfL+gy9Cp/Tv/YVhX/+wwuOpdn5S5f/dIwbwGs2+50oemBodkSw1oiW1QNxdw2Kcng\
sD1bvc=\
"

TELEGRAM_BOT_TOKEN_ENC="\
hF4DGNwPncbTkogSAQdA0TXS29IAQ2n3mowS2uWI8+wosMU2YDo8NLxSiKal7GQw6w/IAH2a9gfzw/dCE+sFyoN\
vC3K55I0HyUIB8ABJ3/FyDNTXm5sTeWgyOoeHTQEt0moBtcKHOEDymVPhnPJVbLtFMtIxtLNYScjZRgTqtLJM7n\
UvdN5joL8GC5cZtttCqozcbHpYetlENBiX4qvIomqdaibdpVsLr5243/Mx5fq5AD60yZPsCFmKD/XrcqVS6ZqDv\
hLqgAkdJBfP\
"

TELEGRAM_CHAT_ID="435004209"

decode() {
    echo $1 | base64 -d | gpg -d
}

podman build -f ~/.images/opencode.Dockerfile -t localhost/opencode:latest
podman run --rm -it \
    --network host \
    -w "$PWD" \
    -v "$PWD:$PWD:rw" \
    -v "$HOME/.local/share/opencode/:/root/.local/share/opencode/:rw" \
    -v "$HOME/.local/state/opencode/:/root/.local/state/opencode/:rw" \
    -v "$HOME/.config/opencode/opencode.json:/root/.config/opencode/opencode.json:ro" \
    -v "$HOME/.config/opencode/AGENTS.md:/root/.config/opencode/AGENTS.md:ro" \
    -v "$HOME/.config/opencode/plugins/telegram-notify.ts:/root/.config/opencode/plugins/telegram-notify.ts:ro" \
    -e "WAYLAND_DISPLAY=$WAYLAND_DISPLAY" \
    -e "XDG_RUNTIME_DIR=/tmp/xdg-runtime" \
    -v "/run/user/$(id -u):/tmp/xdg-runtime:rw" \
    -e "PROXYAPI_API_KEY=$(decode $PROXYAPI_API_KEY_ENC)" \
    -e "ZAI_API_KEY=$(decode $ZAI_API_KEY_ENC)" \
    -e "CONTEXT7_API_KEY=$(decode $CONTEXT7_API_KEY_ENC)" \
    -e "TELEGRAM_BOT_TOKEN=$(decode $TELEGRAM_BOT_TOKEN_ENC)" \
    -e "TELEGRAM_CHAT_ID=$TELEGRAM_CHAT_ID" \
    localhost/opencode:latest
