SHELL=/bin/bash
SPIRE_REPO ?= spiffe/spire
SPIRE_REF  ?= master

all: checkout build-artifact build-services


checkout:
	rm -rf build/repos
	mkdir build/repos
	git clone -b $(SPIRE_REF) git@github.com:$(SPIRE_REPO).git build/repos/spire


build-artifact:
	echo "BUILD-ARTIFACT"


build-services:
	echo "BUILD-SERVICES"

demo:
	echo "DEMO"


clean:
	echo "CLEAN"


.PHONY: checkout build-artifact build-services demo clean



