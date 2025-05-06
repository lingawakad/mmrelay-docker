# M<>M Relay - Dockerized

[Meshtastic <=> Matrix Relay](https://github.com/geoffwhittington/meshtastic-matrix-relay) is a powerful and easy-to-use relay between Meshtastic devices and Matrix chat rooms, allowing seamless communication across platforms.

This project merely Dockerizes it

Available in two flavors - amd64 and arm64 - now with bluetooth support!

# To Use

If you want to connect via bluetooth, ensure that the bluetoothd service on the host is disabled, e.g.```sudo systemctl disable --now bluetooth.service``` so that the container can take control. when the container starts, you'll have to ```docker exec -ti mmrelay.service /bin/bash```, then pair and connect with your meshtastic node (e.g. ```bluetoothctl```, ```pair AA:BB:CC:DD:EE:FF``` and input your code)

Obtain a local copy of the [sample_config.yaml](https://raw.githubusercontent.com/geoffwhittington/meshtastic-matrix-relay/main/sample_config.yaml), modify it per the instructions and your use case, and save it at ```/opt/config.yaml```

i.e.

```wget -O /opt/config.yaml https://raw.githubusercontent.com/geoffwhittington/meshtastic-matrix-relay/main/sample_config.yaml```

```vim /opt/config.yaml```

## systemd
something along these lines should work to run mmrelay as a service:

```/etc/systemd/system/mmrelay.service```

```
[Unit]
Description=M<=>M Relay - Dockerized
Requires=docker.service
After=docker.service

[Service]
Type=simple
ExecStartPre=bash -c '/usr/bin/docker stop --timeout=30 mmrelay 2>/dev/null || true'
ExecStartPre=bash -c '/usr/bin/docker rm mmrelay 2>/dev/null || true'
ExecStartPre=/usr/bin/docker create \
        --rm \
        --init \
        --name=mmrelay \
        --log-driver=none \
        --cap-add=NET_ADMIN \
        --net=host \
        -v /opt/config.yaml:/opt/mmrelay/config.yaml \
        ghcr.io/lingawakad/mmrelay-docker:latest

ExecStart=/usr/bin/docker start --attach mmrelay
ExecStop=bash -c '/usr/bin/docker stop --timeout=30 mmrelay 2>/dev/null || true'
ExecStop=bash -c '/usr/bin/docker rm mmrelay 2>/dev/null || true'

Restart=always
RestartSec=30
SyslogIdentifier=mmrelay

[Install]
WantedBy=multi-user.target
```

Make sure to ```systemctl enable --now mmrelay.service``` to enable and start.

(((note that with this service file logging is through journald, i.e. ```journalctl -fu mmrelay```)))
