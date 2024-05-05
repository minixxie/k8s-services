#!/bin/bash

set -e
scriptPath=$(cd $(dirname "$0") && pwd)
cd "$scriptPath"/..

### k8s nodes
make -s k8s-redo

### the application
make -s -C ./datascience-models local wait test
make -s -C ./qdrant local wait test
make -s -C ./infra-mongodb@7.0.5 local wait test
make -s -C ./ai-private-gpt local wait test
