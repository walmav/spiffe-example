FROM ubuntu:trusty

LABEL Description="Certificate Rotation SPIFFE: Control Plane"
LABEL vendor="SPIFFE"
LABEL version="0.1.0"

RUN apt-get update
RUN apt-get -y install curl unzip git

#TODO: Clone once the repo is public
COPY .repos/sri /root/go/src/github.com/spiffe/sri

ENV PLUGIN_CONFIG_PATH=/root/go/src/github.com/spiffe/sri/control_plane/plugins/.conf

WORKDIR /root/go/src/github.com/spiffe/sri/

RUN ./build.sh setup
RUN ./build.sh all

WORKDIR /root/go/src/github.com/spiffe/sri/control_plane/