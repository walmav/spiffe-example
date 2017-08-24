build:
	rm -rf \
		harness/.repos/ \
		control_plane/.conf/ \
		control_plane/.pconf/ \
		blog/.pconf/ \
		database/.pconf/ \
		.artifact/ \
		|| true
# Create dirs
	mkdir .artifact
	mkdir control_plane/.conf/
	mkdir control_plane/.pconf/
	mkdir blog/.pconf/
	mkdir database/.pconf/
# TODO: Remove once Control Plane and Node Agent are public
	git clone git@github.com:spiffe/sri.git harness/.repos/sri
# Copy configs
	cp harness/.repos/sri/control_plane/.conf/* control_plane/.conf/
	cp harness/.repos/sri/control_plane/plugins/.conf/* control_plane/.pconf/
	cp harness/.repos/sri/node_agent/plugins/.conf/* blog/.pconf/
	cp harness/.repos/sri/node_agent/plugins/.conf/* database/.pconf/
# Build containers
	docker-compose build
	docker-compose up -d

demo:
	docker-compose exec harness cp /root/go/src/github.com/spiffe/sri/artifact.tgz /home/rosemary/.artifact/
	docker-compose exec control_plane tar -xvzf /home/rosemary/.artifact/artifact.tgz -C /
	docker-compose exec blog tar -xvzf /home/rosemary/.artifact/artifact.tgz -C /
	docker-compose exec database tar -xvzf /home/rosemary/.artifact/artifact.tgz -C /
	docker-compose exec harness tmuxinator rosemary

clean:
	docker-compose down
