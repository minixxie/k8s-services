# https://kubevirt.io/quickstart_cloud/

SHELL := /bin/bash

.PHONY: ns
ns:
	echo kubevirt

.PHONY: get
get:
	kubectl -n kubevirt get all

.PHONY: up
up:
	VERSION=$$(curl -s https://storage.googleapis.com/kubevirt-prow/release/kubevirt/kubevirt/stable.txt); \
	echo $$VERSION; \
	kubectl create -f "https://github.com/kubevirt/kubevirt/releases/download/$$VERSION/kubevirt-operator.yaml"; \
	kubectl create -f "https://github.com/kubevirt/kubevirt/releases/download/$$VERSION/kubevirt-cr.yaml"

.PHONY: local
local: up

.PHONY: wait
wait:
	NS=kubevirt DEPLOYMENT="virt-operator" ../scripts/k8s-wait-deployment.sh
	NS=kubevirt DEPLOYMENT="virt-api" ../scripts/k8s-wait-deployment.sh
	NS=kubevirt DEPLOYMENT="virt-controller" ../scripts/k8s-wait-deployment.sh
	NS=kubevirt LABELS="app.kubernetes.io/component=kubevirt" ../scripts/k8s-wait-daemonset.sh

.PHONY: img
img:

.PHONY: test
test:

