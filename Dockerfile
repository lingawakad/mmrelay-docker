# syntax=docker/dockerfile:1

ARG python=python:3-slim

# build stage
FROM ${python} AS build

RUN apt-get update \
  && apt-get install gcc git -y

ADD --chmod=700 https://github.com/geoffwhittington/meshtastic-matrix-relay.git /opt/mmrelay

WORKDIR /opt/mmrelay
ENV PATH="/opt/mmrelay/bin:$PATH"

RUN python -m venv /opt/mmrelay \
  && pip install --upgrade pip \
  && pip install -r requirements.txt

# deploy stage
FROM ${python} AS final

RUN apt-get update \
  && apt-get install git bluetooth bluez bluez-tools -y

COPY --chmod=700 --from=build /opt/mmrelay /opt/mmrelay

ENV PATH="/opt/mmrelay/bin:$PATH"

COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
