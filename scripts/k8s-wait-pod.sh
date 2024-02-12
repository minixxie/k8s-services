#!/bin/bash

set +e;

while : ; do \
	sleep 1; \
	kubectl -n $NS get pod -l "$LABELS" 2>&1 | grep "No resources found" > /dev/null; \
	[[ $? -eq 0 ]] || break; \
done; \
sleep 5; \
kubectl -n $NS wait --for condition=ready --timeout=10m pod -l "$LABELS"
