#!/bin/bash

# vagrant temporarily sets a lock while trying to connect
# retry in case of a deadlock between screen invocations
cd ../../$1
while ! vagrant ssh $2; do
	sleep 1
done
