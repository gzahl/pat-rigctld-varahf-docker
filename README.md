# WineBox64
Dockerfile for running pat, rigctld and vara in a docker image on a aarch64 arm device (e.g. raspberry pi). Vara runs using wine and box86/box64 on a virtual framebuffer with xvfb, which can be viewed using x11vnc or novnc.

## Using
Have Podman and Make available. Build using
```bash
make build
```

Run the container
```bash
make run
```

## Thanks
This is based heavily on
https://github.com/dirtboll/winebox64
https://github.com/WheezyE/Winelink
https://github.com/solarkennedy/wine-x11-novnc-docker

