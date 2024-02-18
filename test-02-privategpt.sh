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

### the application
make -s -C ./datascience-models local wait test
make -s -C ./qdrant local wait test
make -s -C ./mongodb local wait test
cd private-gpt
if [ -f ./minixxie.privategpt.a79e02c36dedb0b981e6cfbcd16b4010cb3a909d.tar ]; then
	./import-image.sh minixxie.privategpt.a79e02c36dedb0b981e6cfbcd16b4010cb3a909d.tar
fi
cd -
make -s -C ./private-gpt local wait test
