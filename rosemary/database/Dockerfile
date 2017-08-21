FROM ubuntu:xenial

LABEL Description="Certificate Rotation SPIFFE: Database"
LABEL vendor="SPIFFE"
LABEL version="0.1.0"

RUN apt-get update
RUN apt-get -y install curl unzip git build-essential

#TODO: Clone once the repo is public
COPY .repos/sri /root/go/src/github.com/spiffe/sri

ENV PLUGIN_CONFIG_PATH=/root/go/src/github.com/spiffe/sri/node_agent/plugins/.conf

WORKDIR /root/go/src/github.com/spiffe/sri/

RUN ./build.sh setup
RUN ./build.sh all

WORKDIR /root/go/src/github.com/spiffe/sri/node_agent/