#!/bin/bash

scriptPath=$(cd $(dirname "$0") && pwd)

source "$scriptPath"/../var.rc

pod=$(kubectl -n $NS get pod | sed 1d | awk '{print $1}')

kubectl cp $NS/$pod:/ragflow/rag/res/bge-large-zh-v1.5/pytorch_model.bin ./pytorch_model.bin
