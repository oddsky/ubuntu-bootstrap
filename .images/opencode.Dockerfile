FROM node:22-trixie

RUN npm install -g opencode-ai@1.17.13

USER 1000

ENTRYPOINT ["/bin/bash"]
