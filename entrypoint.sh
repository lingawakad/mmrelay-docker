#!/bin/bash
service dbus start
service bluetooth start

mmrelay --config /opt/mmrelay/config.yaml
