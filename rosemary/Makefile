all: setup artifact services

setup:
# Clean up dirs
	rm -rf \
		build/repos/ \
		spire/conf/ \
		spire/pconf/ \
		blog/conf/ \
		blog/pconf/ \
		database/conf/ \
		database/pconf/ \
		artifact/ \
		|| true
# Create dirs
	mkdir artifact
	mkdir spire/conf/
	mkdir spire/pconf/
	mkdir blog/conf/
	mkdir blog/pconf/
	mkdir database/conf/
	mkdir database/pconf/
# TODO: Remove once Control Plane and Node Agent are public
	git clone git@github.com:spiffe/sri.git build/repos/sri
	git -C build/repos/sri reset --hard d6ba69e93fe5eb62d1ceb4f57b026bb9c39aabf5 # This demo works with this sri version
	rm build/repos/sri/plugin/server/.conf/join_token.hcl # TODO: this file is breaking server, remove it
# Copy configs
	cp build/repos/sri/cmd/spire-server/.conf/* spire/conf/
	cp build/repos/sri/plugin/server/.conf/* spire/pconf/
	cp build/repos/sri/cmd/spire-agent/.conf/* blog/conf/
	cp build/repos/sri/plugin/agent/.conf/* blog/pconf/
	cp build/repos/sri/cmd/spire-agent/.conf/* database/conf/
	cp build/repos/sri/plugin/agent/.conf/* database/pconf/


artifact:
	docker-compose build build

	docker-compose start build
	docker-compose exec build cp /root/go/src/github.com/spiffe/sri/artifact.tgz /home/rosemary/artifact/
	docker-compose exec build cp /root/go/src/github.com/spiffe/spiffe-example/rosemary/harness/tools/registration/registration /home/rosemary/artifact/
	docker-compose stop build

	cp artifact/artifact.tgz spire/
	cp artifact/artifact.tgz database/
	cp artifact/artifact.tgz blog/
	cp artifact/artifact.tgz harness/
	cp artifact/registration harness/
	
services:
	docker-compose build blog database spire harness

demo:
	docker-compose up -d blog database spire harness
	docker-compose exec harness cp /home/rosemary/harness/rosemary.yml /root/.tmuxinator/rosemary.yml
	docker-compose exec harness tmuxinator rosemary
	docker-compose stop harness

clean:
	docker-compose down

.PHONY: setup artifact services demo clean
