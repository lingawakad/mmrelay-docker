# syntax=docker/dockerfile:1

FROM python:3-slim

RUN useradd --no-log-init --create-home mmrelay

USER mmrelay

WORKDIR /home/mmrelay

ADD https://github.com/geoffwhittington/meshtastic-matrix-relay /home/mmrelay

RUN pip install setuptools wheel \
  && pip install -r requirements.txt

VOLUME /home/mmrelay

ENTRYPOINT main.py
