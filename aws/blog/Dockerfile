FROM ubuntu:xenial

LABEL Description="SPIRE Demo: Blog"
LABEL vendor="scytale.io"
LABEL version="0.1.0"

RUN apt-get update -y
RUN apt-get install -y openssl

#====================
# Setup user accounts
#--------------------
RUN addgroup --gid 101 spire && \
    adduser --uid 1101 --disabled-password --shell /bin/bash --ingroup spire spire

RUN addgroup --gid 110 blog && \
    adduser --uid 1111 --disabled-password --shell /bin/bash --ingroup blog blog



WORKDIR /home/aws

COPY conf /cmd/spire-agent/.conf
COPY pconf /plugin/agent/.conf
COPY .artifacts/artifacts.tgz /
COPY .artifacts/ghostunnel /root/
COPY sidecar_config.hcl /sidecar/
RUN tar --directory / -xvzf /artifacts.tgz

ENV SPIRE_PLUGIN_CONFIG_DIR=/pconf
WORKDIR /cmd/spire-agent/





#====================
# Vault setup: Eventually move to its own container
#--------------------

# Create a vault user and group first so the IDs are the same
RUN addgroup --gid 120 vault && \
    adduser --uid 1010 --disabled-password --shell /bin/bash --ingroup vault vault


RUN mkdir -p /vault/logs && \
    mkdir -p /vault/

# TODO



# Expose the logs directory
VOLUME /valut/logs

# Expose the file directory
VOLUME /vault/file




# CMD ./spire-agent run
