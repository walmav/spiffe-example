#!/bin/bash

docker build -t localhost/spiffe/blog:latest /extra_mount/container_blog
docker push localhost/spiffe/blog

docker build -t localhost/spiffe/ghostunnel:latest /extra_mount/container_ghostunnel
docker push localhost/spiffe/ghostunnel

kubectl delete -f /extra_mount/blog.yaml || true
kubectl create -f /extra_mount/blog.yaml
