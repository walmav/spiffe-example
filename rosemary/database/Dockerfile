FROM ubuntu:xenial

LABEL Description="Certificate Rotation SPIFFE: Database"
LABEL vendor="SPIFFE"
LABEL version="0.1.0"


COPY .pconf/ /node_agent/.pconf/
ENV PLUGIN_CONFIG_PATH=/node_agent/.pconf/
WORKDIR /node_agent/