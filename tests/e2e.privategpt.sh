#!/bin/bash

set -e
scriptPath=$(cd $(dirname "$0") && pwd)
cd "$scriptPath"/..

### k8s nodes
make -s k8s-redo

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
