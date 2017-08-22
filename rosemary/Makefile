build:
# TODO: Remove once Control Plane and Node Agent are public
	rm -rf blog/.repos/ database/.repos/ control_plane/.repos/ || true
	git clone -b ROSEMARY_WIP_DEMO2 git@github.com:spiffe/sri.git blog/.repos/sri
	git clone -b ROSEMARY_WIP_DEMO2 git@github.com:spiffe/sri.git database/.repos/sri
	git clone -b ROSEMARY_WIP_DEMO2 git@github.com:spiffe/sri.git control_plane/.repos/sri
# Build containers
	docker-compose build
	docker-compose up -d

run:
	x-terminal-emulator -e docker-compose exec blog ./node_agent server
	x-terminal-emulator -e docker-compose exec blog bash
	x-terminal-emulator -e docker-compose exec database ./node_agent server
	x-terminal-emulator -e docker-compose exec database bash
	x-terminal-emulator -e docker-compose exec control_plane ./control_plane server
	x-terminal-emulator -e docker-compose exec control_plane bash

demo:
	docker-compose exec harness bash

clean:
	docker-compose down
