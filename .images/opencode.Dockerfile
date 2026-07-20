FROM node:22-trixie

RUN npm install -g opencode-ai@1.18.3

ENTRYPOINT ["/bin/bash"]
