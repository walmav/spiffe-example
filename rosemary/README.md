#  Rosemary Demo

## Setup a total of 3 containers.

### Workload Containers
Two containers that use [Ghostunnel](https://github.com/spiffe/ghostunnel) to establish a channel between 
themselves.

Ghostunnel uses [Go SPIFFE library](https://github.com/spiffe/go-spiffe) to parse and verify the SAN 
URI SPIFFE value.

[Node Agents](https://github.com/spiffe/node-agent) 
[Worklaod Helper](https://github.com/spiffe/spiffe-example/rosemary/workload_helper)

### Control Plane container

One container will have a [Control Plane](https://github.com/spiffe/control-plane) 
Using a SQLite backend database.


### All in one
![GitHub Logo](rosemary_release.png)

### Rosemary Setup  

1. Setup Trust Domain for control plane
- Intermediate cert for trust plane
- Self signed root 
2. Setup NodeAgent for Datatbase and Blog workloads
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
8. Rotate workload SVIDs 

### How to test:

1. [Install Docker Compose](https://docs.docker.com/compose/install/).
2. Clone this repository.
3. Build all containers with `make`.
4. Run the scenario with `make run`. This will create a full tunnel by doing the following:
- Launch a terminal in the database container, with a [netcat](https://www.commandlinux.com/man-page/man1/nc.1.html) command to simulate a database server listening on port 8001.
- Launch a terminal in the database container, showing Ghostunnel running in server mode listening for incoming TLS connections on database:8002 and forwarding them to localhost:8001. The `allow-uri-san` parameter is used to specify what clients with the given URI subject alternative name are allowed.
- Launch a terminal in the blog container, with Ghostunnel running in client mode, listening on localhost:8003 and proxying requests to the TLS server on database:8002.
- Launch a terminal in the blog container, with a netcat command that makes that the standard input is sent to localhost:8003.
5. The scenario can be cleaned running `make clean`.
6. A default valid value is provided for the `allow-uri-san` parameter. Different values can be provided to the Ghostunnel server executing: `make run URI=[my custom uri]`.

Note: The `make run` command assumes the existence of the x-terminal-emulator symbolic link to launch new terminals. 
If this link is not available in your system, replace it with the terminal installed of your preference.

