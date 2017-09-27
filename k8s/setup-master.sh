#!/bin/bash

set -x

curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubelet kubeadm
sudo apt-get install -y docker.io

sudo kubeadm init \
	--pod-network-cidr=10.244.0.0/16 \
	--token=nogood.choiceforasecret \
	--apiserver-advertise-address=10.100.0.10

mkdir /home/ubuntu/.kube
sudo cp /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
sudo chown -R ubuntu:ubuntu /home/ubuntu/.kube

# allow pods to be scheduled on the master
kubectl taint nodes --all node-role.kubernetes.io/master-

export KUBECONFIG=/home/ubuntu/.kube/config

kubectl apply --filename=/vagrant/flannel.yml
	
