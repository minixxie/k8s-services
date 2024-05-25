#!/bin/bash

set -e
scriptPath=$(cd $(dirname "$0") && pwd)
cd "$scriptPath"/..

### k8s nodes
make -s k8s-redo

### the application
#make -s -C ./datascience-models local wait test
#make -s -C ./qdrant local wait test
#cd ./infra-mongodb@7.0.5 && ./img && ./local && ./wait && ./test && cd -
cd ./ai-private-gpt && ./img && ./local && ./wait && ./test && cd -
