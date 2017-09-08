FROM ubuntu:xenial

LABEL Description="Certificate Rotation SPIFFE: Database"
LABEL vendor="SPIFFE"
LABEL version="0.1.0"

RUN apt-get update -y
RUN apt-get install -y openssl

COPY conf /cmd/spire-agent/.conf
COPY pconf /plugin/agent/.conf
COPY artifact.tgz /
COPY ghostunnel /root/
COPY sidecar_config.hcl /sidecar/
RUN tar --directory / -xvzf /artifact.tgz
ENV SPIRE_PLUGIN_CONFIG_DIR=/pconf
WORKDIR /cmd/spire-agent/
CMD ./spire-agent run
