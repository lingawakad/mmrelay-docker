# M<>M Relay - Dockerized

[Meshtastic <=> Matrix Relay](https://github.com/geoffwhittington/meshtastic-matrix-relay) is a powerful and easy-to-use relay between Meshtastic devices and Matrix chat rooms, allowing seamless communication across platforms.

This project merely Dockerizes it

# To Use

Obtain a local copy of the [sample_config.yaml](https://github.com/geoffwhittington/meshtastic-matrix-relay/blob/58037831862c6a3fb1bb6e9db193f8317011263f/sample_config.yaml), modify it per their instructions and your use case, rename it to ```config.yaml``` and provide it to the container at the ```/home/mmrelay``` mount

i.e.

  ```docker run -d --name mmrelay -v ./config.yaml:/home/mmrelay/config.yaml ghcr.io/lingawakad/mmrelay-docker:latest```

If you'd rather use systemd to manage the container, something along these lines should work fine:

```/etc/systemd/system/mmrelay.service```

```
[Unit]
Description=M<=>M Relay - Dockerized
Requires=docker.service
After=docker.service

[Service]
TimeoutStartSec=0
Restart=always
RestartSec=30

ExecStartPre=-/usr/bin/docker stop %n
ExecStartPre=-/usr/bin/docker rm %n
ExecStartPre=/usr/bin/docker pull ghcr.io/lingawakad/mmrelay-docker:latest
ExecStart=/usr/bin/docker run \
                --rm \
                --name=%n \
                --log-driver=none \
                -v /mmrelay/config.yaml:/home/mmrelay/config.yaml \
                ghcr.io/lingawakad/mmrelay-docker:latest

SyslogIdentifier=mmrelay

[Install]
WantedBy=multi-user.target
```
