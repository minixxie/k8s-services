#!/bin/bash

set -e
scriptPath=$(cd $(dirname "$0") && pwd)
cd "$scriptPath"/..

### k8s nodes
make -s k8s-redo

### Application
make -s -C infra-mysql@8.2.0 img local wait test

### TESTS
make -s -C infra-apollo-server-db build up get wait
make -s -C infra-apollo-server img local wait test


echo SUCCESS
