FROM ubuntu:xenial

LABEL Description="Certificate Rotation SPIFFE: Database"
LABEL vendor="SPIFFE"
LABEL version="0.1.0"


COPY wla_secret_file.hcl /node_agent/plugin-conf/
ENV PLUGIN_CONFIG_PATH=/node_agent/plugin-conf/
WORKDIR /node_agent/