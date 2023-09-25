# syntax=docker/dockerfile:1

ARG MMRelay_Version=#0.5.1
ARG python=python:slim

# build stage
FROM ${python} AS build

RUN python -m venv /opt/venv
ENV PATH="/opt/venv/bin:$PATH"
WORKDIR /opt/venv

COPY /mmrelay/ .

RUN pip install -r requirements.txt

# deploy stage
FROM ${python} AS final

RUN useradd --no-log-init --no-create-home mmrelay

USER mmrelay

ENV PATH="/opt/venv/bin:$PATH"
WORKDIR /opt/venv
VOLUME /opt/venv/

COPY --from=build /opt/venv /opt/venv

ENTRYPOINT python main.py
