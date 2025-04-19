# syntax=docker/dockerfile:1

ARG python=python:3-slim

# build stage
FROM ${python}

RUN apt-get update \
  && apt-get install git dbus bluez -y

WORKDIR /opt/mmrelay

RUN pip install mmrelay

COPY ./entrypoint.sh /
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
