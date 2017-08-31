FROM ubuntu:xenial

LABEL Description="Certificate Rotation SPIFFE: Database"
LABEL vendor="SPIFFE"
LABEL version="0.1.0"

COPY conf /conf
COPY pconf /pconf
COPY artifact.tgz /
COPY ghostunnel /root/
RUN tar --directory / -xvzf /artifact.tgz
ENV SPIRE_PLUGIN_CONFIG_DIR=/pconf
ENV SPIRE_AGENT_CONFIG_PATH=/conf/default_agent_config.hcl
WORKDIR /cmd/spire-agent/
CMD ./spire-agent start
