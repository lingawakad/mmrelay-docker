#!/bin/bash
service dbus start
service bluetooth start

/root/.local/bin/mmrelay --config /opt/mmrelay/config.yaml
