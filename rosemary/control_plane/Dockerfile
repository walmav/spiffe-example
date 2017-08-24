FROM ubuntu:xenial

LABEL Description="Certificate Rotation SPIFFE: Control Plane"
LABEL vendor="SPIFFE"
LABEL version="0.1.0"


COPY .conf/ /control_plane/.conf/
COPY .pconf/ /control_plane/.pconf/
ENV PLUGIN_CONFIG_PATH=/control_plane/.pconf/
WORKDIR /control_plane/