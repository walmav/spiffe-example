FROM ubuntu:xenial

LABEL Description="Certificate Rotation SPIFFE: Database"
LABEL vendor="SPIFFE"
LABEL version="0.1.0"


COPY .pconf/ /cmd/spire-agent/.pconf/
ENV PLUGIN_CONFIG_PATH=/cmd/spire-agent/.pconf/
WORKDIR /cmd/spire-agent/