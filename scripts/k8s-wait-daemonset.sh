#!/bin/bash

set +e;

echo "wait DAEMONSET..."
while : ; do \
	sleep 1; \
	kubectl -n $NS get daemonset -l "$LABELS" 2>&1 | grep "No resources found" > /dev/null; \
	[[ $? -eq 0 ]] || break; \
done; \
kubectl -n $NS rollout status --watch --timeout=10m daemonset -l "$LABELS"
echo "daemonset...: $LABELS"

labels=$(kubectl -n $NS describe daemonset -l $LABELS | grep "^Selector:" | awk '{print $NF}')
echo "labels: $labels"
kubectl -n $NS wait --for condition=ready --timeout=10m pod -l "$labels"
