#!/bin/bash

set +e;
CREATION_TIMEOUT=120  # seconds to wait for DaemonSet to be created
ROLLOUT_TIMEOUT=300   # seconds to wait for rollout to complete

ds=$DAEMONSET

echo "== [daemonset/$ds] =="
echo "Waiting for daemonset/$ds to be created..."
elapsed=0
while ! kubectl get daemonset "$ds" -n "$NS" &>/dev/null; do
    if [ $elapsed -ge $CREATION_TIMEOUT ]; then
        echo "ERROR: Timeout waiting for daemonset/$ds to be created"
        exit 1
    fi
    sleep 2
    elapsed=$((elapsed + 2))
done

# Check if DESIRED > 0
desired=$(kubectl get daemonset "$ds" -n "$NS" -o jsonpath='{.status.desiredNumberScheduled}')
if [ -z "$desired" ] || [ "$desired" -eq 0 ]; then
    echo "Skipping daemonset/$ds (DESIRED=$desired)"
    exit 0
fi

echo "Waiting for daemonset/$ds to be ready (DESIRED=$desired)..."
kubectl rollout status daemonset/"$ds" -n "$NS" --timeout="${ROLLOUT_TIMEOUT}s"
