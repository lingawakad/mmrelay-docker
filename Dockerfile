# syntax=docker/dockerfile:1

ARG python=python:3.9-slim

# build stage
FROM ${python} AS build

RUN apt-get update \
  && apt-get install gcc -y

RUN adduser --disabled-password --no-create-home --shell /sbin/nologin mmrelay

USER mmrelay

WORKDIR /home/mmrelay

COPY /meshtastic-matrix-relay/ .

ENV PATH="/home/mmrelay/bin:$PATH"
RUN python -m venv /home/mmrelay

RUN pip install -r requirements.txt

# deploy stage
FROM ${python} AS final

RUN adduser --disabled-password --no-create-home --shell /sbin/nologin mmrelay

USER mmrelay

ENV PATH="/home/mmrelay/bin:$PATH"
WORKDIR /home/mmrelay
VOLUME /home/mmrelay

COPY --from=build /home/mmrelay/ /home/mmrelay/

ENTRYPOINT python main.py
