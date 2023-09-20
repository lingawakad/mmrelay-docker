# M<>M Relay - Dockerized

[Meshtastic <=> Matrix Relay](https://github.com/geoffwhittington/meshtastic-matrix-relay) is a powerful and easy-to-use relay between Meshtastic devices and Matrix chat rooms, allowing seamless communication across platforms.

This project merely Dockerizes it

# To Use

Obtain a local copy of the [sample_config.yaml](https://github.com/geoffwhittington/meshtastic-matrix-relay/blob/58037831862c6a3fb1bb6e9db193f8317011263f/sample_config.yaml), modify it per their instructions and your use case, rename it to ```config.yaml``` and provide it to the container at the ```/home/mmrelay``` mount:

  ```docker run -d --name mmrelay -v ./config.yaml:/home/mmrelay/config.yaml ghcr.io/lingawakad/mmrelay-docker:latest```

# Halp Wanted

If you're better at any of this than i (likely), please help 😅
