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
make -C ./ingress-controller local wait

### the application
make -C ./datascience-models up
make -C ./qdrant local wait
make -C ./mongodb local wait
make -C ./private-gpt local wait
