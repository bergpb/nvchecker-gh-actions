FROM python:3.9.13-alpine3.15 as compile-image

RUN apk update && apk add curl-dev build-base

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"

RUN pip3 install --upgrade pip && \
    pip3 install nvchecker packaging

FROM python:3.9.13-alpine3.15 as build-image

RUN apk add --no-cache bash curl git

COPY --from=compile-image /opt/venv /opt/venv

ENV PATH="/opt/venv/bin:$PATH"
