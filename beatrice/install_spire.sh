#!/bin/bash

SPIRE_TGZ="https://github.com/spiffe/spire/releases/download/0.3pre1/spire-0.3pre1-linux-x86_64-glibc.tgz"

sudo rm -rf /opt/spire*
curl --silent --location $SPIRE_TGZ | sudo tar --directory /opt -xzf -

cd /opt
sudo ln -s spire-* spire
sudo rm -rf /opt/spire/conf
sudo cp -r /extra_mount/spire-conf /opt/spire/conf

