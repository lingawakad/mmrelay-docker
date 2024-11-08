# syntax=docker/dockerfile:1

ARG python=python:3.9-slim

# build stage
FROM ${python} AS build

RUN apt-get update \
  && apt-get install gcc -y
  
RUN useradd mmrelay

USER mmrelay

WORKDIR /opt/mmrelay

COPY /meshtastic-matrix-relay/ .

ENV PATH="/opt/mmrelay/bin:$PATH"
RUN python -m venv /opt/mmrelay

RUN python -m pip install --upgrade pip \
  && pip install -r requirements.txt

# deploy stage
FROM ${python} AS final

RUN apt-get update \
  && apt-get install git -y

RUN useradd mmrelay

USER mmrelay

ENV PATH="/opt/mmrelay/bin:$PATH"
WORKDIR /opt/mmrelay
VOLUME /opt/mmrelay

COPY --from=build /opt/mmrelay/ /opt/mmrelay/
RUN chown -R mmrelay:mmrelay /opt/mmrelay

ENTRYPOINT ["python", "main.py"]
