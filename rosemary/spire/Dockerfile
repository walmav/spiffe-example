FROM ubuntu:xenial

LABEL Description="Certificate Rotation SPIFFE: Control Plane"
LABEL vendor="SPIFFE"
LABEL version="0.1.0"


COPY .conf/ /cmd/spire-server/.conf/
COPY .pconf/ /cmd/spire-server/.pconf/
ENV PLUGIN_CONFIG_PATH=/cmd/spire-server/.pconf/
WORKDIR /cmd/spire-server/