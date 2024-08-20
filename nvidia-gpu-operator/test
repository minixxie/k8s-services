#!/bin/bash

kubectl apply -f nvidia-smi.yaml
kubectl wait --for=condition=complete job/nvidia-smi
kubectl logs $(kubectl get pod -l job-name=nvidia-smi | sed 1d | awk '{print $1}')

if [ "$(which nvidia-smi)" != "" ]; then
	echo "nvidia-smi on bare machine:"
	nvidia-smi
fi

kubectl delete -f nvidia-smi.yaml
