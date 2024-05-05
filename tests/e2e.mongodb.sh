#!/bin/bash

set -e
scriptPath=$(cd $(dirname "$0") && pwd)
cd "$scriptPath"/..

### k8s nodes
make -s k8s-redo

### Application
cd infra-mongodb@7.0.5 && ./local && ./test.sh && cd ..

### TESTS
