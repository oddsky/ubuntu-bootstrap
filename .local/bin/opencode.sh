#!/bin/bash -e

# read KEY
# echo $KEY | gpg --encrypt --recipient <email> --output - | base64

ANTHROPIC_API_KEY_ENC="\
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

podman build -f ~/.images/opencode.Dockerfile -t localhost/opencode:latest
podman run --rm -it \
    --network host \
    -w "$PWD" \
    -v "$PWD:$PWD:rw" \
    -v "$HOME/.config/opencode/opencode.json:/root/.config/opencode/opencode.json:rw" \
    -e "ANTHROPIC_BASE_URL=https://api.proxyapi.ru/anthropic/v1" \
    -e "ANTHROPIC_API_KEY=$(echo $ANTHROPIC_API_KEY_ENC | base64 -d | gpg -d)" \
    -e "ZAI_BASE_URL=https://naomi.nau.im/api" \
    -e "ZAI_API_KEY=$(echo $ZAI_API_KEY_ENC | base64 -d | gpg -d)" \
    localhost/opencode:latest
