#!/bin/bash

( cd ../database && VM_EXTRA_MOUNT=../beatrice vagrant up )
( cd ../k8s && VM_EXTRA_MOUNT=../beatrice vagrant up )

