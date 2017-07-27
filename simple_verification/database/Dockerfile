FROM golang:alpine

LABEL Description="Simple Verification SPIFFE: Database"
LABEL vendor="SPIFFE"

RUN apk update && apk upgrade && \
    apk add --no-cache bash git

RUN apk add --update openssl && \
    rm -rf /var/cache/apk/*

RUN apk add --update make

WORKDIR /spiffe/example/verification/database

RUN git clone https://github.com/spiffe/ghostunnel.git /go/src/github.com/square/ghostunnel
RUN go build -o /usr/bin/ghostunnel github.com/square/ghostunnel

# RUN rm -rf /go/src/*

