# syntax=docker/dockerfile:1

ARG python=python:3.9-slim
ARG mmpath=/opt/mmrelay

# build stage
FROM ${python} AS build

RUN apt-get update \
  && apt-get install gcc -y
  
RUN useradd mmrelay

USER mmrelay

WORKDIR $(mmpath)

COPY /meshtastic-matrix-relay/ .

RUN chown -R mmrelay:mmrelay $(mmpath)

ENV PATH="$(mmpath)/bin:$PATH"
RUN python -m venv $(mmpath)

RUN python -m pip install --upgrade pip \
  && pip install -r requirements.txt

# deploy stage
FROM ${python} AS final

RUN apt-get update \
  && apt-get install git -y

RUN useradd mmrelay

USER mmrelay

ENV PATH="$(mmpath)/bin:$PATH"

COPY --from=build $(mmpath) $(mmpath)

ENTRYPOINT ["python", "main.py"]
