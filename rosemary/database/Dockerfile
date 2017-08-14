FROM ubuntu:trusty

LABEL Description="Certificate Rotation SPIFFE: Database"
LABEL vendor="SPIFFE"
LABEL version="0.1.0"

RUN apt-get update
RUN apt-get -y install curl unzip git

#TODO: Clone once the repo is public
COPY .repos/node_agent /root/go/src/github.com/spiffe/node-agent

ENV PLUGIN_CONFIG_PATH=/root/go/src/github.com/spiffe/node-agent/plugins/.conf

WORKDIR /root/go/src/github.com/spiffe/node-agent

RUN ./build.sh setup
RUN ./build.sh all

WORKDIR /root/go/src/github.com/spiffe/node-agent/node_agent