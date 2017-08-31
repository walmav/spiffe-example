FROM ubuntu:xenial

LABEL Description="Certificate Rotation SPIFFE: build"
LABEL vendor="SPIFFE"
LABEL version="0.1.0"

RUN apt-get update -y
RUN apt-get install -y git curl unzip build-essential

# Build SRI
COPY repos/sri /root/go/src/github.com/spiffe/sri
WORKDIR /root/go/src/github.com/spiffe/sri/
RUN ./build.sh all
RUN ./build.sh artifact

# Build tools
COPY tools/ /root/go/src/github.com/spiffe/spiffe-example/rosemary/build/tools/
WORKDIR /root/go/src/github.com/spiffe/spiffe-example/rosemary/build/tools
RUN ./build.sh all

