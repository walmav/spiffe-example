all: checkout build-artifact build-services

checkout:
	rm -rf build/repos
	mkdir build/repos
	git clone git@github.com:spiffe/sri.git build/repos/sri
#	git -C build/repos/sri checkout workload_api_refactor

build-artifact:
	rm -rf artifact
	mkdir artifact
	docker-compose build build
	docker-compose up -d build
	docker-compose exec build cp /root/go/src/github.com/spiffe/sri/artifact.tgz /home/rosemary/artifact/
	docker-compose exec build cp /root/go/src/github.com/spiffe/spiffe-example/rosemary/harness/tools/registration/registration /home/rosemary/artifact/
	docker-compose exec build cp /root/go/bin/ghostunnel /home/rosemary/artifact/
	docker-compose stop build
	cp artifact/artifact.tgz spire/
	cp artifact/artifact.tgz database/
	cp artifact/artifact.tgz blog/
	cp artifact/artifact.tgz harness/
	cp artifact/registration harness/
	cp artifact/ghostunnel blog/
	cp artifact/ghostunnel database/
	cp artifact/ghostunnel harness/
	
build-services:
	rm -f build/repos/sri/plugin/server/.conf/join_token.hcl # TODO: this file is breaking server, remove it
	rm -rf {spire,blog,database}/{conf,pconf}
	mkdir {spire,blog,database}/{conf,pconf}
	cp build/repos/sri/cmd/spire-server/.conf/* spire/conf/
	cp build/repos/sri/plugin/server/.conf/* spire/pconf/
	cp build/repos/sri/cmd/spire-agent/.conf/* blog/conf/
	cp build/repos/sri/plugin/agent/.conf/* blog/pconf/
	cp build/repos/sri/cmd/spire-agent/.conf/* database/conf/
	cp build/repos/sri/plugin/agent/.conf/* database/pconf/
	docker-compose build blog database spire harness

demo:
	docker-compose up -d blog database spire harness
	docker-compose exec harness cp /home/rosemary/harness/rosemary.yml /root/.tmuxinator/rosemary.yml
	docker-compose exec harness tmuxinator rosemary
	docker-compose stop harness

clean:
	docker-compose down

.PHONY: checkout build-artifact build-services demo clean
