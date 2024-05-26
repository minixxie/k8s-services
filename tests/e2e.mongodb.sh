#!/bin/bash

set -e
scriptPath=$(cd $(dirname "$0") && pwd)
cd "$scriptPath"/..

### k8s nodes
make -s k8s-redo

### Application
make -s -C infra-mongodb@7.0.5 img local wait test

### TESTS


echo SUCCESS
