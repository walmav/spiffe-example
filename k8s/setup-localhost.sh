#!/bin/bash

scp -i .vagrant/machines/master/virtualbox/private_key \
	-o StrictHostKeyChecking=no \
	ubuntu@10.100.0.10:.kube/config admin.conf
