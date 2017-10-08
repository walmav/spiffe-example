#!/bin/bash

cat << _EOF > sidecar_config.hcl
agentAddress = "$AGENT_SOCKET"
ghostunnelCmd = "/home/ubuntu/ghostunnel client --listen $LISTEN --target $UPSTREAM"
certDir = "certs"
_EOF

mkdir -p certs

while true; do
	./sidecar
	sleep 1
done
