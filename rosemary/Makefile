build:
# Clean up dirs
	rm -rf \
		harness/.repos/ \
		spire/.conf/ \
		spire/.pconf/ \
		blog/.conf/ \
		blog/.pconf/ \
		database/.conf/ \
		database/.pconf/ \
		.artifact/ \
		|| true
# Create dirs
	mkdir .artifact
	mkdir spire/.conf/
	mkdir spire/.pconf/
	mkdir blog/.conf/
	mkdir blog/.pconf/
	mkdir database/.conf/
	mkdir database/.pconf/
# TODO: Remove once Control Plane and Node Agent are public
	git clone git@github.com:spiffe/sri.git harness/.repos/sri
	git -C harness/.repos/sri reset --hard d6ba69e93fe5eb62d1ceb4f57b026bb9c39aabf5 # This demo works with this sri version
	rm harness/.repos/sri/plugin/server/.conf/join_token.hcl # TODO: this file is breaking server, remove it
# Copy configs
	cp harness/.repos/sri/cmd/spire-server/.conf/* spire/.conf/
	cp harness/.repos/sri/plugin/server/.conf/* spire/.pconf/
	cp harness/.repos/sri/cmd/spire-agent/.conf/* blog/.conf/
	cp harness/.repos/sri/plugin/agent/.conf/* blog/.pconf/
	cp harness/.repos/sri/cmd/spire-agent/.conf/* database/.conf/
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
