# syntax=docker/dockerfile:1
# test change

ARG python=python:alpine

# build stage
FROM ${python} AS build

RUN apk add build-base

RUN adduser -D mmrelay

USER mmrelay

WORKDIR /home/mmrelay/venv

RUN python -m venv /home/mmrelay/venv
ENV PATH="/home/mmrelay/venv/bin:$PATH"

COPY /mmrelay/ .

RUN pip install -r requirements.txt

# deploy stage
FROM ${python} AS final

RUN apk add --no-cache libstdc++

RUN adduser -D mmrelay

USER mmrelay

ENV PATH="/home/mmrelay/venv/bin:$PATH"
WORKDIR /home/mmrelay/venv
VOLUME /home/mmrelay/venv/

COPY --from=build /home/mmrelay/venv /home/mmrelay/venv

ENTRYPOINT python main.py
