FROM nvidia/cuda:12.9.1-base-ubuntu24.04

LABEL org.opencontainers.image.authors="siem.dejong@radboudumc.nl"

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install --no-install-recommends --yes \
        ca-certificates \
        git \
        # for remote development
        openssh-server \
        # for torch compile
        g++ \
        && rm -rf /var/lib/apt/lists/* \
        > /dev/null && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY --from=ghcr.io/astral-sh/uv:latest /uv /bin/uv

ENV UV_CACHE_DIR=/opt/uv-cache/
ENV UV_LINK_MODE=copy
ENV UV_PROJECT_ENVIRONMENT=/opt/uv/.venv
ENV PATH="$UV_PROJECT_ENVIRONMENT/bin:$PATH"
ENV COMMON_SYNC_ARGS=""

WORKDIR /app

RUN --mount=type=cache,target=$UV_CACHE_DIR \
    --mount=type=bind,source=uv.lock,target=uv.lock \
    --mount=type=bind,source=pyproject.toml,target=pyproject.toml \
    --mount=type=bind,source=LICENSE,target=LICENSE \
    --mount=type=bind,source=README.md,target=README.md \
    --mount=type=bind,source=.python-version,target=.python-version \
    uv sync --locked --no-install-project $COMMON_SYNC_ARGS

ADD . /app

RUN --mount=type=cache,target=$UV_CACHE_DIR \
    uv sync $COMMON_SYNC_ARGS