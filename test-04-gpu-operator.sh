#!/bin/bash

set -e

### k8s nodes
if [ "$1" == colima ]; then
	colima stop --force
	colima delete --force
	make colima
else  # assume k3s on ubuntu
	make k3s-redo
fi

### basic softwares
#make -s -C ./ingress-controller local wait
make -s -C ./nvidia-gpu-operator local wait test

### the application
