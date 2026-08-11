#!/bin/bash -e

# read KEY; echo $KEY | gpg --encrypt --recipient rossamakhin01@gmail.com --output - | base64

PROXYAPI_API_KEY_ENC="\
hF4DGNwPncbTkogSAQdA2JRerCuRCXWvHDMxiGPeFpho8k7pHYjTdigEvz3J90wwvYxoPAZmDSxo\
0jfe+OBlHkzwRXbGvT5mD3mX9SQZ8RMSjJ1TSDpzhyEGL5r1O8yz0l8BRleKLtG5YctOSV0E+0pt\
7MF5y1d1B/fPYmYXwWRnJ/84MGuRm2PQBEwcR/Ek17FI3sAO04SYcuKIYkwRWRYuMdKy07I3VcGO\
PFpZ0YFTR/4XBjm6ZpGN49iwM1BEvQ==\
"

ZAI_API_KEY_ENC="\
hF4DGNwPncbTkogSAQdAGgNvJbgbQG0KKEAiyjbdJNmTuk979zDSCbn65pPfcAIwD2pLtTnyUmBB\
E1s+9/Zd1eqZQuUSDiuQAZlHjTwHhulMGeF1EVMTadqoW0c2utGp0l8BpVhLTdbg60STMA9vAt59\
nRg903PMQ7NcFxlRPi6QXms51o36C5dVtodx5IhxAnLj3DYe3pcpl+vbjNpWCfpd4CPFkoDgJZrW\
hUQUCcc6SiLmkskFGTbtZjmEWG44Yg==\
"

CONTEXT7_API_KEY_ENC="\
hF4DGNwPncbTkogSAQdA3SjxPFc4Y3W1roURn9JPA8vIaPMBPVcUXaWFNeHZxTYwymZUsOvwNXVf\
3QtFbiyKR9XC78+iuogG1+KEgaAjKjRxxXkXYjlTTTZltLVxj5hY0mYB1N0dPBgEpBfz0kJhTub/\
+hrWna799Gtq3+Np4+dTlxJv7TuPNb4doJi15mEJy5npfL+gy9Cp/Tv/YVhX/+wwuOpdn5S5f/dI\
wbwGs2+50oemBodkSw1oiW1QNxdw2KcngsD1bvc=\
"

TELEGRAM_BOT_TOKEN_ENC="\
hF4DGNwPncbTkogSAQdA0TXS29IAQ2n3mowS2uWI8+wosMU2YDo8NLxSiKal7GQw6w/IAH2a9gfz\
w/dCE+sFyoNvC3K55I0HyUIB8ABJ3/FyDNTXm5sTeWgyOoeHTQEt0moBtcKHOEDymVPhnPJVbLtF\
MtIxtLNYScjZRgTqtLJM7nUvdN5joL8GC5cZtttCqozcbHpYetlENBiX4qvIomqdaibdpVsLr524\
3/Mx5fq5AD60yZPsCFmKD/XrcqVS6ZqDvhLqgAkdJBfP\
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
