#!/bin/bash

set -x

VERS=1.7.5

cat <<_EOF | sudo tee /etc/hosts
10.90.0.100 k8s-node
127.0.0.1 localhost
_EOF

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet=${VERS}-00 kubeadm=${VERS}-00 kubectl=${VERS}-00
sudo apt-get install -y docker.io

sudo kubeadm join \
	--token=nogood.choiceforasecret \
	10.90.0.10:6443

