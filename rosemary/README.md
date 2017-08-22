#  Certificate Rotation Demo

This demo shows two workloads communicating over Ghostunnel, and Spiffe taking care of the certificate rotation for the encrypted tunnel.

## Components

This demo is composed of 3 containers: two workloads with their respective node agents, and one control plane.

### Workload Containers

Two containers use [Ghostunnel](https://github.com/spiffe/ghostunnel) to establish a channel between 
themselves.

Ghostunnel uses [Go SPIFFE library](https://github.com/spiffe/go-spiffe) to parse and verify the SAN URI SPIFFE value.

In each of these containers there is a [Node Agent](https://github.com/spiffe/node-agent) and a [Workload Helper](https://github.com/spiffe/spiffe-example/rosemary/workload_helper).

### Control Plane Container

One container has a [Control Plane](https://github.com/spiffe/control-plane) with a SQLite backend database.


### Diagram

![GitHub Logo](rosemary_release.png)

### Registration Entries

#### Nodes registration entries

There is one entry per node. In both cases there is a single selector of type 'Token', and the parent is the Control Plane.

```bash 
selectors: Token/TokenBlog  
spiffe_id: spiffe://dev.rexsco.com/spiffe/node-id/TokenBlog  
parent_id: spiffe://dev.rexsco.com/spiffe/cp  

selectors: Token/TokenDatabase  
spiffe_id: spiffe://dev.rexsco.com/spiffe/node-id/TokenDatabase  
parent_id: spiffe://dev.rexsco.com/spiffe/cp  
```

#### Workloads registration entries

There is also one entry per workload. In both cases there are two selectors: type 'hash' and 'uid', and the parent is its corresponding node.

selectors: hash/hashstring, uid/1001  
spiffe_id: spiffe://dev.rexsco.com/Blog  
parent_id: spiffe://dev.rexsco.com/spiffe/node-id/TokenBlog  
  
selectors: hash/hashstring, uid/1001  
spiffe_id: spiffe://dev.rexsco.com/Database  
parent_id: spiffe://dev.rexsco.com/spiffe/node-id/TokenDatabase  


## Details

These are the steps performed by the demo:

1. Setup Trust Domain for control plane
- Intermediate cert for trust plane
- Self signed root 
2. Setup NodeAgent for Database and Blog workloads
- Seed with CP trust bundle
- Seed with CP IP 
- Seed with CP SPIFFE ID (if we are using well known Trust Domain, CP SPIFFE ID can be derived)
3. Setup DataStore on CP
- First Phase: Insert data into SQLite 
- Second Phase: Write Script to call registration API to insert Workload data. 
4. Bootstrap Workload helper with the NA Workload API destination 
5. Bootstrap NodeAgent attestation with join token (have to replicate token into CP)
6. Initiate NodeAgent Bootstrap and Attestation 
7. Initiate Blog to Database traffic.
8. Rotate workload SVIDs.

### How to Run

These are the steps to run the demo:

1. Clone this repo
2. Change to 'rosemary/' directory and run 'make'
- This will build the containers and it usually takes several minutes
3. Run 'make demo'
- This will open 3 pairs of daemon and daemon CLI consoles (one pair for Control Plane
and two pairs for the Node Agents)
4. In the daemon CLI consoles you can run commands against the corresponding daemon
- The daemon CLI name is 'node\_agent' for Node Agent and 'control\_plane' for Control Plane
- There are two commands available: 'plugin-info' to list the loaded plugins, and 'stop' to stop the daemon
- For example, to stop the Control Plane daemon you need to run './control_plane stop'
5. In the control plane CLI console you can run the registration process
- Change to '~/go/bin' and run './registration'
6. To stop the containers run 'make clean'