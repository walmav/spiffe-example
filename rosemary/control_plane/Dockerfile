FROM ubuntu:xenial

LABEL Description="Certificate Rotation SPIFFE: Control Plane"
LABEL vendor="SPIFFE"
LABEL version="0.1.0"


COPY default_cp_config.hcl /control_plane/.conf/
COPY ds_sqlite.hcl /control_plane/plugin-conf/
ENV PLUGIN_CONFIG_PATH=/control_plane/plugin-conf/
WORKDIR /control_plane/