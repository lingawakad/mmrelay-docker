# M<>M Relay - Dockerized

[Meshtastic <=> Matrix Relay](https://github.com/geoffwhittington/meshtastic-matrix-relay) is a powerful and easy-to-use relay between Meshtastic devices and Matrix chat rooms, allowing seamless communication across platforms.

This project merely Dockerizes it

Available in two flavors - amd64 and arm64
  - amd64 is confirmed to work
  - arm64 is untested

# To Use

It is probably best to run the container as a non-root user, i.e. and put the config.yaml in ```/opt``` or ```/srv``` or something. Make sure it is owned by the new user

Obtain a local copy of the [sample_config.yaml](https://github.com/geoffwhittington/meshtastic-matrix-relay/blob/58037831862c6a3fb1bb6e9db193f8317011263f/sample_config.yaml), modify it per their instructions and your use case, rename it to ```config.yaml``` and provide it to the container at the ```/home/mmrelay``` mount 

i.e.

```wget -O /opt/config.yaml https://github.com/geoffwhittington/meshtastic-matrix-relay/blob/58037831862c6a3fb1bb6e9db193f8317011263f/sample_config.yaml```

```make your changes to config.yaml```

```useradd -M -s /bin/false mmrelay && chown mmrelay:mmrelay /opt/config.yaml```

Add the service to your docker-compose.yml:

```
  mmrelay-docker:
    container_name: mmrelay
    user: mmrelay:mmrelay
    read_only: true
    cap_drop:
      - ALL
    volumes:
      - /opt/config.yaml:/home/mmrelay/config.yaml
    image: ghcr.io/lingawakad/mmrelay-docker:latest
```

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
                --user=mmrelay:mmrelay \
                --read-only \
                --cap-drop=ALL \
                -v /opt/config.yaml:/home/mmrelay/config.yaml \
                ghcr.io/lingawakad/mmrelay-docker:latest

SyslogIdentifier=mmrelay

[Install]
WantedBy=multi-user.target
```
(((note that in this example ```systemctl status mmrelay``` works, and logging is through journald, i.e. ```journalctl -fu mmrelay```)))
