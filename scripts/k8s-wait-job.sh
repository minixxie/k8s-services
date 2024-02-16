#!/bin/bash

set +e;
#kubectl -n $NS wait --for condition=Available=True --timeout=10m deploy $DEPLOYMENT

while : ; do \
	sleep 1; \
	kubectl -n $NS get job "$JOB" > /dev/null; \
	[[ $? -ne 0 ]] || break; \
done; \
kubectl -n $NS wait --for=condition=complete --timeout=10m job "$JOB"
