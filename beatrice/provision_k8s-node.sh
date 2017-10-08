#!/bin/bash

# install and start spire-agent
/extra_mount/install_spire.sh
sudo cp /extra_mount/systemd/spire-agent.service /etc/systemd/system/
sudo systemctl daemon-reload
sudo systemctl restart spire-agent.service

