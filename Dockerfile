# syntax=docker/dockerfile:1

ARG python=python:3-slim
ARG version=0.5.1

# build stage
FROM ${python} AS build

ENV VIRTUAL_ENV=/opt/venv
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

ADD /mmrelay/ .

RUN pip install setuptools wheel \
  && pip install -r requirements.txt

# final stage
FROM ${python} AS run

LABEL org.opencontainers.image.description "A powerful and easy-to-use relay between Meshtastic devices and Matrix chat rooms, allowing seamless communication across platforms"
LABEL org.opencontainers.image.title "MMRelay"
LABEL org.opencontainers.image.version ${version}

RUN useradd --no-log-init --create-home mmrelay

USER mmrelay

COPY --from=build /opt/venv /home/mmrelay/venv
ENV PATH="/home/mmrelay/venv/bin:$PATH"

WORKDIR /home/mmrelay/venv

VOLUME /home/mmrelay/venv

ENTRYPOINT main.py
