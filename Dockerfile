# syntax=docker/dockerfile:1

# version control
ARG MMRelay_Version=#0.5.1

# this is a python app, so use python base
FROM python:3-slim-bookworm

# install sqlite3
#RUN apt-get update && apt-get install -y --no-install-recommends \
#  sqlite3 \
#  && rm -rf /var/lib/apt/lists/* \
#  && rm -rf /tmp/*

# don't run as root
RUN useradd --no-log-init --create-home mmrelay

USER mmrelay

WORKDIR /home/mmrelay

# should probably change this to a copy?
ADD https://github.com/geoffwhittington/meshtastic-matrix-relay.git${MMRelay_Version} /home/mmrelay

# make a place to mount config.yaml
VOLUME /home/mmrelay

# python gonna python
RUN pip install -r requirements.txt

ENTRYPOINT python main.py
