#!/bin/bash

set -e
scriptPath=$(cd $(dirname "$0") && pwd)
cd "$scriptPath"/..

### k8s nodes
make -s k8s-redo

### basic softwares
make -s -C ./nvidia-gpu-operator img local wait test

### the application
make -s -C ./ai-nutlope-llamacoder img local wait test


echo SUCCESS
