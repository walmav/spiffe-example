FROM ubuntu:xenial

LABEL Description="Certificate Rotation SPIFFE: Blog"
LABEL vendor="SPIFFE"
LABEL version="0.1.0"

RUN apt-get update -y
RUN apt-get install -y openssl

#====================
# Setup user accounts
#--------------------
RUN addgroup spire && \
    adduser -u 1001 -S -G spire spire

RUN addgroup blog && \
    adduser -u 1011 -S -G blog blog


COPY conf /cmd/spire-agent/.conf
COPY pconf /plugin/agent/.conf
COPY artifact.tgz /
COPY ghostunnel /root/
COPY sidecar_config.hcl /sidecar/
RUN tar --directory / -xvzf /artifact.tgz
ENV SPIRE_PLUGIN_CONFIG_DIR=/pconf
WORKDIR /cmd/spire-agent/





#====================
# Vault setup: Eventually move to its own container
#--------------------

# Create a vault user and group first so the IDs are the same
RUN addgroup valut && \
    adduser -u 1010 -S -G vault vault


RUN mkdir -p /vault/logs && \
    mkdir -p /vault/

# TODO



# Expose the logs directory
VOLUME /valut/logs

# Expose the file directory
VOLUME /vault/file




CMD ./spire-agent run
