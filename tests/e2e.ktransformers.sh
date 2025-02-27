#!/bin/bash

set -e
scriptPath=$(cd $(dirname "$0") && pwd)
cd "$scriptPath"/..

### k8s nodes
make -s k8s-redo

### basic softwares
make -s -C ./nvidia-gpu-operator img local wait test

### the application
./datascience-models/models/DeepSeek-V3.sh
./datascience-models/models/DeepSeek-V3-GGUF.sh
make -s -C ./datascience-models local wait test

make -s -C ./ai-ktransformers img local wait test


echo SUCCESS
