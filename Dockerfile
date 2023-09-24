# syntax=docker/dockerfile:1

ARG MMRelay_Version=#0.5.1

FROM python:3-slim-bookworm

RUN useradd --no-log-init --create-home mmrelay

USER mmrelay

WORKDIR /home/mmrelay

ADD https://github.com/geoffwhittington/meshtastic-matrix-relay.git${MMRelay_Version} /home/mmrelay

VOLUME /home/mmrelay

RUN pip install -r requirements.txt

ENTRYPOINT python main.py
