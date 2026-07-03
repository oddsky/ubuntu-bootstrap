#!/bin/bash -e

# read KEY
# echo $KEY | gpg --encrypt --recipient <email> --output - | base64

ANTHROPIC_API_KEY_ENC="\
hF4DGNwPncbTkogSAQdA2JRerCuRCXWvHDMxiGPeFpho8k7pHYjTdigEvz3J90wwvYxoPAZmDSxo\
0jfe+OBlHkzwRXbGvT5mD3mX9SQZ8RMSjJ1TSDpzhyEGL5r1O8yz0l8BRleKLtG5YctOSV0E+0pt\
7MF5y1d1B/fPYmYXwWRnJ/84MGuRm2PQBEwcR/Ek17FI3sAO04SYcuKIYkwRWRYuMdKy07I3VcGO\
PFpZ0YFTR/4XBjm6ZpGN49iwM1BEvQ==\
"
ANTHROPIC_API_KEY=$(echo $ANTHROPIC_API_KEY_ENC | base64 -d | gpg -d)

podman build -f ~/.images/opencode.Dockerfile -t localhost/opencode:latest
podman run --rm -it \
    --network host \
    -w "$PWD" \
    -v "$PWD:$PWD:rw" \
    -v "$HOME/.config/opencode/opencode.json:/home/node/.config/opencode/opencode.json:rw" \
    -e "ANTHROPIC_BASE_URL=https://api.proxyapi.ru/anthropic/v1" \
    -e "ANTHROPIC_API_KEY=$ANTHROPIC_API_KEY" \
    -e "ZAI_BASE_URL=" \
    -e "ZAI_API_KEY=" \
    localhost/opencode:latest
