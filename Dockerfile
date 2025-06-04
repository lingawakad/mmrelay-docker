# syntax=docker/dockerfile:1

ARG python=python:3-alpine

# build stage
FROM ${python}

WORKDIR /opt/mmrelay

RUN apk update \
    && apk add git dbus bluez pipx -y \
    && pipx install mmrelay

COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
