#!/bin/bash

set +e;
#kubectl -n $NS wait --for condition=Available=True --timeout=10m deploy $DEPLOYMENT

while : ; do \
	sleep 1; \
	kubectl -n $NS get deployment "$DEPLOYMENT" > /dev/null; \
	[[ $? -ne 0 ]] || break; \
done; \
kubectl -n $NS rollout status --watch --timeout=10m deployment "$DEPLOYMENT"

labels=$(kubectl -n $NS describe deployment $DEPLOYMENT | grep Selector: | awk '{print $NF}')
kubectl -n $NS wait --for condition=ready --timeout=10m pod -l "$labels"
