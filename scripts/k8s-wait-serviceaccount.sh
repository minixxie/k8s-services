#!/bin/bash

set +e;

while : ; do \
	sleep 1; \
	kubectl -n $NS get serviceaccount "$SERVICE_ACCOUNT" 2>&1 | grep "NotFound" > /dev/null; \
	[[ $? -eq 0 ]] || break; \
done
