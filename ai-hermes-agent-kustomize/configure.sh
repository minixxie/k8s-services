#!/bin/bash

set -e

podName=$(kubectl -n $(make -s --no-print-directory ns) get pod | sed 1d | awk '{print $1}')

sh=$(kubectl -n $(make -s --no-print-directory ns) exec $podName -- ls /bin/bash)
if [ "$sh" == "" ]; then
	sh=$(kubectl -n $(make -s --no-print-directory ns) exec $podName -- ls /bin/sh)
fi

kubectl -n $(make -s --no-print-directory ns) exec -it $podName -- $sh -c "/opt/hermes/docker/entrypoint.sh model"

kubectl -n $(make -s --no-print-directory ns) exec -it $podName -- $sh -c "/opt/hermes/docker/entrypoint.sh gateway setup"

kubectl -n $(make -s --no-print-directory ns) rollout restart deploy/ai-hermes-agent
