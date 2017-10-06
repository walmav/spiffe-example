#!/bin/bash

cat <<_EOF | sudo mysql
drop user 'dbuser'@'%';
create user 'dbuser'@'%' identified by 'badpass';
grant all on *.* to 'dbuser'@'%';
flush privileges;
drop database forum_db;
create database forum_db;
_EOF

cat /extra_mount/forum_db.dump | sudo mysql forum_db

sudo apt-get -y install build-essential libltdl-dev

mkdir -p /home/ubuntu/go
export PATH=/usr/local/go/bin://home/ubuntu/go/bin:$PATH

if ! which go; then
	wget -O /tmp/go.tgz https://storage.googleapis.com/golang/go1.9.1.linux-amd64.tar.gz
	sudo tar --directory /usr/local -xzf /tmp/go.tgz
fi

go get github.com/square/ghostunnel
cp /home/ubuntu/go/bin/ghostunnel /extra_mount/container_ghostunnel/

