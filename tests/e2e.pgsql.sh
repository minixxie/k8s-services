#!/bin/bash

set -e
scriptPath=$(cd $(dirname "$0") && pwd)
cd "$scriptPath"/..

### k8s nodes
make -s k8s-redo

### Application
cd infra-pgsql@15.1.0 && ./img && ./local && ./wait && ./test && cd -

### TESTS


echo "SUCCESS"
