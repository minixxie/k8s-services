#!/bin/bash

set -e
scriptPath=$(cd $(dirname "$0") && pwd)
cd "$scriptPath"/..

### k8s nodes
make -s k8s-redo

### Application
cd apollo-server-go && ./img && ./local && ./wait && ./test && cd -

### TESTS


echo "SUCCESS"
