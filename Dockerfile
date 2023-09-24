# syntax=docker/dockerfile:1

FROM python:3-slim

RUN useradd --no-log-init --create-home mmrelay

USER mmrelay

WORKDIR /home/mmrelay

ADD /mmrelay/ .

ENV VIRTUAL_ENV=/home/mmrelay
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN pip install setuptools wheel \
  && pip install -r requirements.txt

VOLUME /home/mmrelay

ENTRYPOINT main.py
