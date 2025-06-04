# syntax=docker/dockerfile:1

ARG python=python:3-alpine

# build stage
FROM ${python}

WORKDIR /opt/mmrelay

RUN apt-get update \
    && apt-get install git dbus bluez pipx -y \
    && pipx install mmrelay

COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
