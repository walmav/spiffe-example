#!/bin/bash

# Set default value for URI if not defined in the first argument
set -x
URI="$1"
if [ "$URI" = "" ]; then
    URI="spiffe://blog.example.org/path/service"
fi

/home/ghostunnel/ghostunnel client \
   --listen 0.0.0.0:3306 \
   --target database:3306 \
   --keystore /keys/client.key.pem \
   --cacert /keys/ca-chain.cert.pem

