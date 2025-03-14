#!/bin/bash
service dbus start
service bluetooth start

python /opt/mmrelay/main.py
