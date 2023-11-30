SHELL := /bin/bash

.PHONY: up
up:
	curl -sL https://github.com/operator-framework/operator-lifecycle-manager/releases/download/v0.26.0/install.sh | bash -s v0.26.0

.PHONY: local
local: up

.PHONY: wait
wait:
	NS=olm DEPLOYMENT="olm-operator" ../scripts/k8s-wait-deployment.sh
	NS=olm DEPLOYMENT="catalog-operator" ../scripts/k8s-wait-deployment.sh
	NS=olm DEPLOYMENT="packageserver" ../scripts/k8s-wait-deployment.sh
	NS=olm LABELS="olm.catalogSource=operatorhubio-catalog" ../scripts/k8s-wait-pod.sh
