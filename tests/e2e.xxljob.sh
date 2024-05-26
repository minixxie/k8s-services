#!/bin/bash

set -e
scriptPath=$(cd $(dirname "$0") && pwd)
cd "$scriptPath"/..

### k8s nodes
make -s k8s-redo

### Application
make -s -C infra-mysql@8.2.0 img local wait test
make -s -C infra-xxljob img local wait test

### TESTS


echo SUCCESS
