#!/bin/bash

set -e
scriptPath=$(cd $(dirname "$0") && pwd)
cd "$scriptPath"/..

### k8s nodes
make -s k8s-redo

### Application
make -s -C infra-qdrant img local wait test

### TESTS


echo SUCCESS
