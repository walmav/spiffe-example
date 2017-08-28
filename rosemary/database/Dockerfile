FROM ubuntu:xenial

LABEL Description="Certificate Rotation SPIFFE: Database"
LABEL vendor="SPIFFE"
LABEL version="0.1.0"


COPY .conf/ /cmd/spire-agent/.conf/
COPY .pconf/ /cmd/spire-agent/.pconf/
ENV SPIRE_PLUGIN_CONFIG_DIR=/cmd/spire-agent/.pconf/
WORKDIR /cmd/spire-agent/