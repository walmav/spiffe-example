FROM ubuntu:xenial

LABEL Description="SPIRE Demo: ghostunnel"
LABEL vendor="scytale.io"
LABEL version="0.1.0"

RUN apt-get update -y
RUN apt-get -y install \
	git \
	wget

WORKDIR /home/ubuntu

COPY ghostunnel .
COPY start.sh .
RUN wget -O- https://github.com/spiffe/sidecar/releases/download/0.1/sidecar_0.1_linux_amd64.tar.gz | tar xzf -

CMD ./start.sh


