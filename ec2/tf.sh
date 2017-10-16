#!/bin/bash

declare -rx TF_VAR_region="us-east-2"
declare -rx TF_VAR_az="a"
declare -rx TF_VAR_cidr="10.70.0.0/24"

declare -rx TF_VAR_private_ip_blog="10.70.0.10"
declare -rx TF_VAR_private_ip_database="10.70.0.20"
declare -rx TF_VAR_private_ip_server="10.70.0.30"

declare -rx TF_VAR_ssh_priv_key="demo_ssh_key"
declare -rx TF_VAR_ssh_pub_key="demo_ssh_key.pub"

if [[ ! -r $TF_VAR_ssh_priv_key ]]; then
	ssh-keygen -N '' -f $TF_VAR_ssh_priv_key
fi

terraform "$@"
