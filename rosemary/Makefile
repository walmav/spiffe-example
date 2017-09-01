SHELL=/bin/bash
SPIRE_REPO ?= evan2645/sri
SPIRE_REF  ?= TEST-ONLY-disable-tls-for-debugging

all: checkout build-artifact build-services

checkout:
	rm -rf build/repos
	mkdir build/repos
	git clone -b $(SPIRE_REF) git@github.com:$(SPIRE_REPO).git build/repos/sri

build-artifact:
	rm -rf artifact spire/upstreamca-memory-keys/
	mkdir artifact spire/upstreamca-memory-keys/
	docker-compose build build
	docker-compose up -d build
	docker-compose exec build cp /root/go/src/github.com/spiffe/sri/artifact.tgz /home/rosemary/artifact/
	docker-compose exec build cp /root/go/bin/ghostunnel /home/rosemary/artifact/
	docker-compose exec build cp /root/go/src/github.com/spiffe/spiffe-example/rosemary/build/tools/registration/registration /home/rosemary/artifact/
	docker-compose exec build cp /root/go/src/github.com/spiffe/spiffe-example/rosemary/build/tools/registration/registration.json /home/rosemary/artifact/
	docker-compose exec build cp /root/go/src/github.com/spiffe/spiffe-example/rosemary/build/tools/sidecar/sidecar /home/rosemary/artifact/
	docker-compose stop build
	cp artifact/artifact.tgz spire/
	cp artifact/artifact.tgz database/
	cp artifact/artifact.tgz blog/
	cp artifact/artifact.tgz harness/
	cp artifact/registration harness/
	cp artifact/ghostunnel blog/
	cp artifact/ghostunnel database/
	cp artifact/ghostunnel harness/
	cp build/repos/sri/plugin/server/upstreamca-memory/pkg/_test_data/keys/* spire/upstreamca-memory-keys/
	
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
	cp blog/custom_conf/* blog/conf/
	cp blog/custom_pconf/* blog/pconf/
	cp database/custom_conf/* database/conf/
	cp database/custom_pconf/* database/pconf/
	cp spire/custom_pconf/* spire/pconf/
	docker-compose build blog database spire harness

demo:
	docker-compose up -d blog database spire harness
	docker-compose exec blog cp /home/rosemary/artifact/sidecar /sidecar/sidecar
	docker-compose exec database cp /home/rosemary/artifact/sidecar /sidecar/sidecar
	docker-compose exec harness cp /home/rosemary/harness/rosemary.yml /root/.tmuxinator/rosemary.yml
	docker-compose exec harness tmuxinator rosemary
	docker-compose stop harness

clean:
	docker-compose down

.PHONY: checkout build-artifact build-services demo clean
