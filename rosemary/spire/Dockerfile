FROM ubuntu:xenial

LABEL Description="Certificate Rotation SPIFFE: Control Plane"
LABEL vendor="SPIFFE"
LABEL version="0.1.0"

COPY conf /conf
COPY pconf /pconf
COPY artifact.tgz /
COPY upstreamca-memory-keys /plugin/server/upstreamca-memory/pkg/_test_data/keys
RUN tar --directory / -xvzf /artifact.tgz
ENV SPIRE_PLUGIN_CONFIG_DIR=/pconf
ENV SPIRE_SERVER_CONFIG=/conf/default_server_config.hcl
WORKDIR /cmd/spire-server/
CMD ./spire-server start
