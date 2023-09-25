# syntax=docker/dockerfile:1

ARG python=python:alpine

# build stage
FROM ${python} AS build

RUN apk add build-base

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
WORKDIR /opt/venv

COPY /mmrelay/ .

RUN pip install -r requirements.txt

# deploy stage
FROM ${python} AS final

RUN apk add --no-cache libstdc++

RUN adduser -DH mmrelay

USER mmrelay

ENV PATH="/opt/venv/bin:$PATH"
WORKDIR /opt/venv
VOLUME /opt/venv/

COPY --from=build /opt/venv /opt/venv

ENTRYPOINT python main.py
