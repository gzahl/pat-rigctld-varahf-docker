FROM debian:bookworm-slim as box-build

ENV DEBIAN_FRONTEND="noninteractive"

# Install libraries needed to compile box
RUN dpkg --add-architecture armhf \
 && apt-get update \
 && apt-get install -y --no-install-recommends --no-install-suggests git wget curl cmake python3 build-essential gcc-arm-linux-gnueabihf libc6-dev-armhf-cross libc6:armhf libstdc++6:armhf ca-certificates

WORKDIR /root

# Build box86
RUN git clone https://github.com/ptitSeb/box86 \
 && mkdir box86/build \
 && cd box86/build \
 && cmake .. -DRPI4ARM64=1 -DARM_DYNAREC=ON -DCMAKE_BUILD_TYPE=RelWithDebInfo \
 && make -j$(nproc) \
 && make install DESTDIR=/box 

# Build box64
#RUN git clone https://github.com/ptitSeb/box64 \
# && mkdir box64/build \
# && cd box64/build \
# && cmake .. -DRPI4ARM64=1 -DARM_DYNAREC=ON -DCMAKE_BUILD_TYPE=RelWithDebInfo \
# && make -j$(nproc) \
# && make install DESTDIR=/box

FROM docker.io/golang:1.22.2-bookworm AS pat-build
WORKDIR /pat
RUN go install github.com/la5nta/pat@latest

FROM docker.io/caddy:2.7-builder-alpine AS caddy-build
RUN xcaddy build

FROM debian:bookworm-slim as wine-build

# Install libraries needed to run box
RUN dpkg --add-architecture armhf \
 && apt-get update \
 && apt-get install --yes --no-install-recommends wget curl libc6:armhf libstdc++6:armhf ca-certificates

# `cabextract` is needed by winetricks to install most libraries
# If you are sure you don't need it, feel free to remove
RUN apt-get install --yes --no-install-recommends cabextract xvfb x11vnc fluxbox unzip libhamlib-utils supervisor xterm

# Clean up
RUN apt-get -y autoremove \
 && apt-get clean autoclean \
 && rm -rf /tmp/* /var/tmp/* /var/lib/apt/lists

ENV WINE32PREFIX=/root/.config/wine32
ENV WINE64PREFIX=/root/.config/wine64

# Install wine, wine64, and winetricks
COPY install-wine.sh /
RUN bash /install-wine.sh \
 && rm /install-wine.sh

# Install box wrapper for wine
COPY wrap-wine.sh /
RUN bash /wrap-wine.sh \
 && rm /wrap-wine.sh

FROM wine-build

# Copy compiled box86 and box64 binaries
COPY --from=box-build /box /
COPY --from=pat-build /go/bin/pat /usr/bin/pat
COPY --from=caddy-build /usr/bin/caddy /usr/bin/caddy

RUN apt-get install --yes --no-install-recommends \
  xvfb x11vnc fluxbox xterm \
  unzip supervisor \
  libhamlib-utils

WORKDIR /root

ENV X11VNC_PASSWORD="123456"

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD ./run-vara.sh /root/run-vara.sh
ADD ./bootstrap.sh /root/bootstrap.sh

# VNC
EXPOSE 5900
# PAT
EXPOSE 443
# supervisor
EXPOSE 9001

CMD ["/usr/bin/supervisord"]
