#!/bin/bash

set +e;

while : ; do \
	sleep 1; \
	kubectl -n $NS get statefulset "$STATEFULSET" > /dev/null; \
	[[ $? -ne 0 ]] || break; \
done; \
kubectl -n $NS rollout status --watch --timeout=10m statefulset "$STATEFULSET"
