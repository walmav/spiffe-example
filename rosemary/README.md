#  Certificate Rotation Demo

This demo shows two workloads communicating over Ghostunnel using generated SVID. A SPIRE deployment takes care of the 
node and workload attestation. After attestation has been established, the Workload sidecar will perform certificate rotation 
for the workload SVIDs at a configured TTL interval.

## Components

This demo is composed of 4 containers: two workloads with their respective SPIRE agents, one SPIRE server and a 
test harness.

### Workload Containers

Two containers use [Ghostunnel](https://github.com/spiffe/ghostunnel) to establish a channel between 
themselves.

Ghostunnel uses [Go SPIFFE library](https://github.com/spiffe/go-spiffe) to parse and verify the SAN URI SPIFFE value.

In each of these containers there is a [Spire Agent](https://github.com/spiffe/sri/cmd/spire-agent) and a [Workload Sidecar](https://github.com/spiffe/spiffe-example/rosemary/build/tools/sidecar).

### Spire Server Container

One container has a [Spire Server](https://github.com/spiffe/sri/cmd/spire-server) with a SQLite data store database.


### Diagram

![GitHub Logo](rosemary_release.png)

### Registration Entries

#### Nodes registration entries

There is one entry per node. In both cases there is a single selector of type 'Token', and the parent is the Control Plane.

| Selectors | SPIFFE ID | PARENT ID |
| :------ | :----- | :----------- |
| Token/TokenBlog  |  spiffe://localhost/spiffe/node-id/TokenBlog | spiffe://localhost/spiffe/cp |  
| Token/TokenDatabase | spiffe://localhost/spiffe/node-id/TokenDatabase | spiffe://localhost/spiffe/cp |  


#### Workloads registration entries

There is also one entry per workload. In both cases there are two selectors: type 'hash' and 'uid', and the parent is its corresponding node.

| Selectors | SPIFFE ID | PARENT ID |
| :------ | :----- | :----------- |
| hash/hashstring, uid/1001  | spiffe://localhost/Blog  | spiffe://localhost/spiffe/node-id/TokenBlog |  
| hash/hashstring, uid/1001  | spiffe://localhost/Database   | spiffe://localhost/spiffe/node-id/TokenDatabase |  


## Details

These are the steps performed by the demo:

1. Setup Trust Domain for SPIRE server
- Intermediate cert for SPIRE server
- Self signed root 
2. Setup Spire Agent for Database and Blog workloads
- Seed with SPIRE server trust bundle
- Seed with SPIRE server IP 
- Seed with SPIRE SPIFFE ID (if we are using well known Trust Domain, SPIRE Server SPIFFE ID can be derived)
3. Setup DataStore on Spire Server
- Call registration API to insert Workload data. (Using CLI [registration](/build/tools/registration) ) 
4. Bootstrap Workload Sidecar with the SPIRE Agent Workload API destination 
5. Bootstrap SPIRE Agent attestation with join token (have to replicate token into SPIRE Server)
6. Initiate SPIRE Agent Bootstrap and Attestation 
7. Initiate Blog to Database traffic.
8. Rotate workload SVIDs.

### How to Run

These are the steps to run the demo:

1. Clone this repo
2. Change to 'rosemary/' directory and run 'make'
- This will build the containers and it usually takes several minutes
3. Run 'make demo'
- This will open tmuxinator with 7 panes: 3 pairs of daemon and daemon log panes (one pair for SPIRE Server
and two pairs for the SPIRE Agents) and one pane for the main console (aka harness)
- The 3 daemons will be already running on one side, and on the other side you can see the logs for each daemon
4. To run commands against one of the daemons run 'docker-compose exec {blog,database,spire} bash' in the main/harness console and then run the command
- The daemon CLI is './spire-agent' for SPIRE Agent and './spire-server' for SPIRE server
- Run the daemon CLI without arguments to see the valid options
5. In the main/harness console you can run the registration process
- Change to 'artifact/' and run './registration'
6. To see the SVID generated for the nodes you need to run the following command in its container: 'openssl x509 -in base_svid.crt -noout -text'
6. To exit tmuxinator press 'Ctrl+B' then '&' and confirm with 'Y'
7. To stop the containers run 'make clean'