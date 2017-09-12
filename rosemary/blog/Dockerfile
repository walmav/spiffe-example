FROM ubuntu:xenial

LABEL Description="Certificate Rotation SPIFFE: Blog"
LABEL vendor="SPIFFE"
LABEL version="0.1.0"

RUN apt-get update -y
RUN apt-get install -y openssl

COPY conf /spire/.conf
COPY pconf /spire/plugin/agent/.conf
COPY artifact.tgz /
COPY ghostunnel /root/
COPY sidecar_config.hcl /sidecar/
RUN tar --directory / -xvzf /artifact.tgz
WORKDIR /spire/
CMD ./spire-agent run
