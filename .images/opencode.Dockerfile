FROM node:22-trixie

RUN npm install -g opencode-ai@1.17.13

ENTRYPOINT ["/bin/bash"]
