#!/bin/bash

set -x

# wait for registry to become available
while ! nc -w 1 -z localhost 80; do
	sleep 1
done

docker build -t localhost/spiffe/blog:latest /extra_mount/blog/container_blog
docker push localhost/spiffe/blog

docker build -t localhost/spiffe/ghostunnel:latest /extra_mount/blog/container_ghostunnel
docker push localhost/spiffe/ghostunnel

kubectl delete -f /extra_mount/blog/blog.yaml || true
kubectl create -f /extra_mount/blog/blog.yaml

# install and start spire-server
/extra_mount/install_spire.sh server
