#!/bin/bash

set -e

kubectl exec -it pod/datascience-models -- sh -c 'cd /datascience-models && ls -l *.sh'
