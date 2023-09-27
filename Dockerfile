# syntax=docker/dockerfile:1

ARG python=python:slim

# build stage
FROM ${python} AS build

RUN apt-get update \
  && apt-get install gcc -y

RUN adduser --disabled-password mmrelay

USER mmrelay

WORKDIR /home/mmrelay

RUN python -m venv /home/mmrelay
ENV PATH="/home/mmrelay/bin:$PATH"

COPY /mmrelay/ .

RUN pip install -r requirements.txt

# deploy stage
FROM ${python} AS final

RUN adduser --disabled-password mmrelay

USER mmrelay

ENV PATH="/home/mmrelay/bin:$PATH"
WORKDIR /home/mmrelay
VOLUME /home/mmrelay

COPY --from=build /home/mmrelay/ /home/mmrelay/

ENTRYPOINT python main.py
