# Kubernetes Workload Attestation Demo

This demo shows two workloads communicating over Ghostunnel authenticated with SVIDs.

One workload, a simple bulletin board, is running as a Kubernetes service and is attested by the
spire-agent against the state known by the local kubelet.

The other workload is a database running in its own VM outside of the Kubernetes cluster, attested by its PID.

Within the Kubernetes cluster, the spire-agent and spire-server are deployed as ordinary, non-privileged, processes on the master and nodes.

Both Ghostunnel processes are managed by the SPIRE Sidecar, which implements calls out to the Workload API, writing of certificates to the filesystem, and signaling Ghostunnel when a new certificate is available.

The blog will be available at http://10.90.0.10:30080/

![Beatrice Diagram](doc/beatrice_diagram.png)

## Creating the demo

Prerequisites:

* Vagrant
* Virtualbox
* Docker on the host machine (optional, for tmux-based harness)

The following steps can be accomplished with `make build-services`:

1. Create the database VM
  1. Deploy spire-agent
  1. Build ghostunnel
1. Create the kubernetes cluster
  1. Deploy spire-agent to the Kubernetes Node VM
  1. Deploy spire-server to the Kubernetes Master VM
  1. Create and register the application containers
1. Shut down the Vagrant VMs
1. Create the harness/tmux container

## Running the demo

(step 1-2 can be accomplished with `make demo`)

1. Start the Kubernetes and Database VMs
1. Run the harness container to set up SSH connections to the Kubernetes node and
   master and the database VM
1. Inject the registration config into spire-server
1. Generate two join tokens on the Kubernetes master with spire-server
1. On the Kubernetes node, launch spire-agent with one join token
1. On the Database VM, launch spire-agent with the other join token
1. Deploy the application service to the Kubernetes cluster

## FAQ
