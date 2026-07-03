FROM node:22-trixie

ARG UV_VER=0.9.8@sha256:08f409e1d53e77dfb5b65c788491f8ca70fe1d2d459f41c89afa2fcbef998abe

ENV CLAUDE_CONFIG_DIR="/claude" \
    PATH="/root/.local/bin:$PATH" \
    UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy

RUN npm install -g @anthropic-ai/claude-code@~2.1.0

COPY --from=ghcr.io/astral-sh/uv:${UV_VER} /uv /bin/uv

RUN mkdir -p /claude

RUN --mount=type=cache,target=/root/.cache/uv \
    uv tool install serena-agent

ENTRYPOINT ["/bin/bash"]
