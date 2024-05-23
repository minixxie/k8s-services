#!/bin/bash

set -e
scriptPath=$(cd $(dirname "$0") && pwd)
cd "$scriptPath"/..

### k8s nodes
make -s k8s-redo

### Application
cd infra-mysql@8.2.0 && ./local && ./test.sh && cd ..
cd infra-xxljob && ./local && ./test.sh && cd ..

### TESTS
