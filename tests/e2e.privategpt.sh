#!/bin/bash

set -e
scriptPath=$(cd $(dirname "$0") && pwd)
cd "$scriptPath"/..

### k8s nodes
make -s k8s-redo

### the application
#make -s -C ./datascience-models local wait test
make -s -C ./qdrant local wait test
cd ./infra-mongodb@7.0.5 && ./local && ./test.sh && cd -
cd ./ai-private-gpt && ./local && ./test.sh && cd -
