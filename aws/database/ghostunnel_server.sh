#!/bin/bash

# Set default value for URI if not defined in the first argument
set -x
URI="$1"
if [ "$URI" = "" ]; then
    URI="spiffe://blog.example.org/path/service"
fi

ghostunnel server \
    --listen database:6306 \
    --target localhost:3306 \
    --keystore /keys/server.key.pem \
    --cacert /keys/ca-chain.cert.pem \
    --allow-uri-san $URI
