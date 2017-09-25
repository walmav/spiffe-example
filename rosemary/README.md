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

In each of these containers there is a [Spire Agent](https://github.com/spiffe/sri/tree/master/cmd/spire-agent) and a [Workload Sidecar](/rosemary/build/tools/sidecar).

### Spire Server Container

One container has a [Spire Server](https://github.com/spiffe/sri/tree/master/cmd/spire-server) with a SQLite data store database.


### Diagram

![GitHub Logo](rosemary_release.png)

### Registration Entries

There is also one entry per workload. In both cases there are two selectors: type 'hash' and 'uid', and the parent is its corresponding node.

| Selectors | SPIFFE ID | PARENT ID |
| :------ | :----- | :----------- |
| unix/uid:1111  | spiffe://example.org/Blog  | spiffe://example.org/spiffe/node-id/TokenBlog |  
| unix/uid:1111  | spiffe://example.org/Database   | spiffe://example.org/spiffe/node-id/TokenDatabase |  


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
- Call registration API to insert Workload data. (Using CLI [registration](/rosemary/build/tools/registration) ) 
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
3. Run 'make demo' and it will open tmuxinator with 7 panes
- From top to bottom:
- Blog (Agent) CLI | Blog sidecar
- Database (Agent) CLI | Database sidecar
- Server CLI | Server logs
- Main console (aka harness)
4. Use the right panes (CLI) to run commands
- The daemon CLI is './spire-agent' for SPIRE Agent and './spire-server' for SPIRE server
- Run the daemon CLI without arguments to see the valid options
5. To see the SVID generated for the agents you need to run the following command in its container: 'openssl x509 -in base_svid.crt -noout -text'
6. You can run netcat in the agents CLI to simulate the workloads
- In Database CLI run './nc.sh'
- In Blog CLI run './nc.sh'
- You should be able to type text in one of the nc instances and see the echo in the other after pressing Enter key
7. To exit tmuxinator press 'Ctrl+B' then '&' and confirm with 'Y'
8. To stop the containers run 'make clean'