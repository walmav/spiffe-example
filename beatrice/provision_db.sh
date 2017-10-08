#!/bin/bash

GOLANG_URL=https://storage.googleapis.com/golang/go1.9.1.linux-amd64.tar.gz
GHOSTUNNEL_BRANCH=spiffe-support

# wipe any exsting DB config
cat <<_EOF | sudo mysql || true
drop user 'dbuser'@'%';
drop database forum_db;
_EOF

cat <<_EOF | sudo mysql
create user 'dbuser'@'%' identified by 'badpass';
grant all on *.* to 'dbuser'@'%';
flush privileges;
create database forum_db;
_EOF

# restore our static forum_db dump
cat /extra_mount/blog/forum_db.dump | sudo mysql forum_db

# install and start spire-agent
/extra_mount/install_spire.sh
sudo cp /extra_mount/systemd/spire-agent.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl restart spire-agent.service

## complicated build of ghostunnel branch for use by this VM
## and for inclusion in the Docker container
## we deploy to Kubernetes
##
## this is build on the DB VM because it's a handy Linux machine

sudo apt-get -y install build-essential libltdl-dev git

export PATH=/usr/local/go/bin:/home/ubuntu/go/bin:$PATH
# abusing .bash_aliases to ammend PATH, for convenience
echo "export PATH=/usr/local/go/bin:/home/ubuntu/go/bin:$PATH" > /home/ubuntu/.bash_aliases

# ghostunnel requires golang1.9, so we fetch a tarball
if ! which go; then
	curl --silent $GOLANG_URL | sudo tar --directory /usr/local -xzf -
fi

mkdir -p /home/ubuntu/go/src/github.com/spiffe
cd /home/ubuntu/go/src/github.com/spiffe
git clone --branch $GHOSTUNNEL_BRANCH  https://github.com/spiffe/ghostunnel.git
cd ghostunnel
go install

# send a copy to our container friend
cp /home/ubuntu/go/bin/ghostunnel /extra_mount/blog/container_ghostunnel/

