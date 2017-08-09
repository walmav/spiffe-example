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

TBD

