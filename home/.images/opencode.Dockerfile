FROM node:22-trixie

RUN apt-get update && apt-get install -y --no-install-recommends wl-clipboard \
    && rm -rf /var/lib/apt/lists/* \
    && npm install -g opencode-ai@1.18.3

ENTRYPOINT ["/bin/bash"]
