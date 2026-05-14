FROM python:3.12-alpine

ARG UV_VER=0.9.8@sha256:08f409e1d53e77dfb5b65c788491f8ca70fe1d2d459f41c89afa2fcbef998abe

WORKDIR /workspace

RUN mkdir -p /workspace

ENV PATH="/root/.local/bin:$PATH" \
    UV_COMPILE_BYTECODE=1 \
    UV_LINK_MODE=copy

RUN --mount=type=cache,target=/root/.cache/uv \
    --mount=from=ghcr.io/astral-sh/uv:${UV_VER},source=/uv,target=/bin/uv \
    uv tool install aider-chat

ENTRYPOINT ["/bin/sh"]
