# syntax=docker/dockerfile:1

ARG python=python:3.9-slim

# build stage
FROM ${python} AS build

RUN apt-get update \
  && apt-get install gcc -y

RUN useradd mmrelay

USER mmrelay

ADD --chown=mmrelay:mmrelay https://github.com/geoffwhittington/meshtastic-matrix-relay.git /opt/mmrelay

WORKDIR /opt/mmrelay
ENV PATH="/opt/mmrelay/bin:$PATH"

RUN python -m venv /opt/mmrelay \
  && python -m pip install --upgrade pip \
  && pip install --user -r requirements.txt

# deploy stage
FROM ${python} AS final

RUN apt-get update \
  && apt-get install git -y

RUN useradd mmrelay

USER mmrelay

WORKDIR /opt/mmrelay

ENV PATH="/opt/mmrelay/bin:$PATH"

COPY --chown=mmrelay:mmrelay --from=build /opt/mmrelay /opt/mmrelay

CMD ["python", "main.py"]
