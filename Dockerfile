# syntax=docker/dockerfile:1

ARG MMRelay_Version=#0.5.0

FROM python:3-slim-bookworm

RUN apt-get update && apt-get install -y --no-install-recommends \
  sqlite3 \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /tmp/*

RUN useradd --no-log-init --create-home --shell /bin/sh mmrelay

USER mmrelay

WORKDIR /srv

ADD https://github.com/geoffwhittington/meshtastic-matrix-relay.git${MMRelay_Version} /srv

VOLUME /srv

RUN pip install -r requirements.txt

ENTRYPOINT python main.py
