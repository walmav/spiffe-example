# Vagrant Kubernetes 

## Prerequistes

* Vagrant
* Virtualbox
* kubectl (optional)

macOS (with homebrew):

```
brew cask install virtualbox
brew cask install vagrant
brew install kubernetes-cli # optional
```

## Using

In this directory:

```
vagrant up
```

This will create a master (k8s-master, 10.90.0.10, 1GB RAM) and one
node (k8s-node-1, 10.90.0.100, 1GB RAM).

To connect to the cluster VMs with SSH:

```
vagrant ssh k8s-master
vagrant ssh k8s-node-1
```

To copy off the kubectl config needed to remotely manage the cluster:

```
vagrant ssh-config > $HOME/.ssh/vagrant_ssh_config
scp -F $HOME/.ssh/vagrant_ssh_config k8s-master:.kube/config /tmp/admin.conf
KUBECONFIG=/tmp/admin.conf kubectl get all --all-namespaces
```

To install the dashboard, run on the master:

```
kubectl create -f /vagrant/dashboard.yaml
```

The dashboard will be available (unauthenticated) at http://10.90.0.10:30001

### Private docker registry:

A private docker registry is available on master and all nodes as
well as from the host machine on port 80.

From a node or master (user ubuntu is in group docker, so no sudo necessary):
```
docker pull alpine
docker tag $(docker images alpine:latest --format="{{.ID}}") localhost/alpine
docker push localhost/alpine
```

From host machine:
```
docker pull alpine
docker tag $(docker images alpine:latest --format="{{.ID}}") 10.90.0.10/alpine
docker push 10.90.0.10/alpine
```

## Customizing

Setting `VM_EXTRA_MOUNT` will mount an additional host directory at `/extra_mount`

All scripts in `/extra_mount` named `provision_<hostname>*.sh` will be executed
at the end of the provisioning process (trailing node number will be removed.)

See Vagrantfile to tweak:

* Kubernetes version (1.7 and 1.6 supported)
* IP addresses
* Number of nodes
* RAM allocations

