SHELL=/bin/bash
SPIRE_REPO ?= spiffe/spire
SPIRE_REF  ?= master

AWS_DOMAIN   ?= s3.us-east-2.amazonaws.com
SPIRE_HASH   ?= ef3ce96
SPIRE_OS     ?= linux-x86-64
SPIRE_ART    ?= artifacts/artifacts.tgz
GHOST_ART   ?= artifacts/ghostunnel

# https://s3.us-east-2.amazonaws.com/scytale-artifacts/spire/spire-ef3ce96-linux-x86_64-glibc.tgz

all: checkout build-artifact build-services


checkout:
	rm -rf artifacts
	mkdir artifacts
	rm -rf build/repos
	mkdir build/repos
	curl -o $(SPIRE_ART) https://$(AWS_DOMAIN)/scytale-artifacts/spire/spire-$(SPIRE_HASH)-$(SPIRE_OS)-glibc.tgz


build-artifact:
	echo "BUILD-ARTIFACT"
	docker-compose build build
	docker-compose up -d build
	docker-compose exec build cp /root/go/bin/ghostunnel /home/artifacts
	docker-compose stop build
	cp $(SPIRE_ART) spire/
	cp $(SPIRE_ART) blog/
	cp $(SPIRE_ART) database/
	docker-compose build blog 

build-services:
	echo "BUILD-SERVICES"

demo:
	echo "DEMO"

clean:
	docker-compose down


.PHONY: checkout build-artifact build-services demo clean



