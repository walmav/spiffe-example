FROM ubuntu:xenial

LABEL Description="SPIRE Demo: ghostunnel"
LABEL vendor="scytale.io"
LABEL version="0.1.0"

RUN apt-get update -y
RUN apt-get -y install \
	git

WORKDIR /home/ubuntu
COPY ghostunnel /home/ubuntu

EXPOSE 3306

CMD true

