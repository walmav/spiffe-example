build:
# TODO: Remove once Control Plane is public
	rm -rf control_plane/.repos/control_plane || true
	git clone git@github.com:spiffe/control-plane.git control_plane/.repos/control_plane
#	make -C blog
#	make -C database
	make -C control_plane
	docker-compose up -d

run:
	x-terminal-emulator -e docker-compose exec database /nc.sh
	x-terminal-emulator -e docker-compose exec database /ghostunnel_server.sh $(URI)
	x-terminal-emulator -e docker-compose exec blog /ghostunnel_client.sh
	x-terminal-emulator -e docker-compose exec blog /nc.sh

clean:
	docker-compose down
