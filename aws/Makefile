SHELL=/bin/bash
SPIRE_REPO ?= spiffe/spire
SPIRE_REF  ?= master

AWS_DOMAIN   ?= s3.us-east-2.amazonaws.com
SPIRE_HASH   ?= ef3ce96
SPIRE_OS     ?= linux-x86_64
ART_DIR      ?= .artifacts
SPIRE_ART    ?= $(ART_DIR)/artifacts.tgz
GHOST_ART   ?= $(ART_DIR)/ghostunnel

# https://s3.us-east-2.amazonaws.com/scytale-artifacts/spire/spire-ef3ce96-linux-x86_64-glibc.tgz

all: checkout build-artifact build-services


checkout:
	rm -rf $(ART_DIR)
	mkdir $(ART_DIR)
	curl -o $(SPIRE_ART) https://$(AWS_DOMAIN)/scytale-artifacts/spire/spire-$(SPIRE_HASH)-$(SPIRE_OS)-glibc.tgz


build-artifact:
	echo "BUILD-ARTIFACT"
	rm -rf {spire,blog,database}/$(ART_DIR)
	mkdir  {spire,blog,database}/$(ART_DIR)
	docker-compose build build
	docker-compose up -d build
	docker-compose exec build cp /root/go/bin/ghostunnel /home/artifacts
	docker-compose stop build
	cp $(SPIRE_ART) spire/${ART_DIR}/
	cp $(SPIRE_ART) blog/${ART_DIR}/
	cp $(SPIRE_ART) database/${ART_DIR}/
	cp $(GHOST_ART) blog/${ART_DIR}/
	cp $(GHOST_ART) database/${ART_DIR}/


build-services:
	echo "BUILD-SERVICES"
	rm -rf .mariadb
	mkdir  .mariadb
	docker-compose build blog
	docker-compose build database
	docker-compose build harness 

demo:
	echo "DEMO"
	docker compose up -d spire
	sleep 5 
	docker-compose up -d blog database harness 

clean:
	docker-compose down


.PHONY: checkout build-artifact build-services demo clean



