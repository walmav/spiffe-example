build:
# TODO: Remove once Control Plane and Node Agent are public
	rm -rf control_plane/.repos/control_plane blog/.repos/node_agent database/.repos/node_agent || true
	git clone git@github.com:spiffe/control-plane.git control_plane/.repos/control_plane
	git clone -b CONFIGURE_PLUGINS_OPTIONAL_CHECKSUM git@github.com:spiffe/node-agent.git blog/.repos/node_agent
	git clone -b CONFIGURE_PLUGINS_OPTIONAL_CHECKSUM git@github.com:spiffe/node-agent.git database/.repos/node_agent
# Build containers
	docker-compose build
	docker-compose up -d

run:
	x-terminal-emulator -e docker-compose exec blog ./node_agent server
	x-terminal-emulator -e docker-compose exec blog bash
#	x-terminal-emulator -e docker-compose exec control_plane bash
#	x-terminal-emulator -e docker-compose exec database bash

clean:
	docker-compose down
