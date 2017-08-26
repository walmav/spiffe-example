build:
# Clean up dirs
	rm -rf \
		harness/.repos/ \
		spire/.conf/ \
		spire/.pconf/ \
		blog/.pconf/ \
		database/.pconf/ \
		.artifact/ \
		|| true
# Create dirs
	mkdir .artifact
	mkdir spire/.conf/
	mkdir spire/.pconf/
	mkdir blog/.pconf/
	mkdir database/.pconf/
# TODO: Remove once Control Plane and Node Agent are public
	git clone git@github.com:spiffe/sri.git harness/.repos/sri
	git -C harness/.repos/sri reset --hard 27aeb2600de3f73233de8f2d53aceaec1218c1e1 # This demo works with this sri version
	rm harness/.repos/sri/plugin/server/.conf/join_token.hcl # TODO: this file is breaking server, remove it
# Copy configs
	cp harness/.repos/sri/cmd/spire-server/.conf/* spire/.conf/
	cp harness/.repos/sri/plugin/server/.conf/* spire/.pconf/
	cp harness/.repos/sri/plugin/agent/.conf/* blog/.pconf/
	cp harness/.repos/sri/plugin/agent/.conf/* database/.pconf/
# Build containers
	docker-compose build
	docker-compose up -d

demo:
	docker-compose exec harness cp /root/go/src/github.com/spiffe/sri/artifact.tgz /home/rosemary/.artifact/
	docker-compose exec spire tar -xvzf /home/rosemary/.artifact/artifact.tgz -C /
	docker-compose exec blog tar -xvzf /home/rosemary/.artifact/artifact.tgz -C /
	docker-compose exec database tar -xvzf /home/rosemary/.artifact/artifact.tgz -C /
	docker-compose exec harness tmuxinator rosemary

clean:
	docker-compose down
