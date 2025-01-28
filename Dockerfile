FROM python:3.12-alpine3.19 AS base

RUN apk update \
    && apk add \
    curl-dev \
    build-base

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN pip3 install --upgrade pip && \
    pip3 install nvchecker packaging


FROM base AS build

RUN apk add \
    --no-cache \
    bash \
    curl \
    git

COPY --from=base /opt/venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"
