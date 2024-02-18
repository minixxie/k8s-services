#!/bin/bash

set +e;

while : ; do \
	sleep 1; \
	kubectl -n $NS get statefulset "$STATEFULSET" > /dev/null; \
	[[ $? -ne 0 ]] || break; \
done; \
kubectl -n $NS rollout status --watch --timeout=10m statefulset "$STATEFULSET"

labels=$(kubectl -n $NS describe statefulset $STATEFULSET | grep Selector: | awk '{print $NF}')
kubectl -n $NS wait --for condition=ready --timeout=10m pod -l "$labels"
