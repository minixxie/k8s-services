#!/bin/bash

scriptPath=$(cd $(dirname "$0") && pwd)
cd "$scriptPath"/..

set -e

### k8s nodes
make -s k8s-redo

make -s ragflow

### TESTS
