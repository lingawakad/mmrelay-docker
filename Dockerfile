# syntax=docker/dockerfile:1

ARG python=python:3.9-slim
ARG mmpath=/opt/mmrelay

# build stage
FROM ${python} AS build

RUN apt-get update \
  && apt-get install gcc -y
  
RUN useradd -m -s /bin/bash mmrelay

USER mmrelay

WORKDIR $(mmpath)

COPY /meshtastic-matrix-relay/ .

ENV PATH="$(mmpath)/bin:$PATH"
RUN python -m venv $(mmpath)

RUN python -m pip install --upgrade pip \
  && pip install -r requirements.txt

# deploy stage
FROM ${python} AS final

RUN apt-get update \
  && apt-get install git -y

RUN useradd -m -s /bin/bash mmrelay

USER mmrelay

WORKDIR $(mmpath)

ENV PATH="$(mmpath)/bin:$PATH"

COPY --chown mmrelay:mmrelay --from=build $(mmpath) $(mmpath)

ENTRYPOINT ["python", "main.py"]
