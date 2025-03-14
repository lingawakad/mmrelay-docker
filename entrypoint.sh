#!/bin/bash
service dbus start
service bluez start

python /opt/mmrelay/main.py
