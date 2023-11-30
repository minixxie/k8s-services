SHELL := /bin/bash

.PHONY: ls
ls:
	kubectl -n operators get crd -l app.kubernetes.io/name=opentelemetry-operator
	kubectl -n operators get subscription my-opentelemetry-operator
	kubectl -n operators get all -l app.kubernetes.io/name=opentelemetry-operator,control-plane=controller-manager

.PHONY: up
up:
	kubectl apply -f https://operatorhub.io/install/opentelemetry-operator.yaml

.PHONY: local
local: up

.PHONY: wait
wait:
	NS=operators DEPLOYMENT="opentelemetry-operator-controller-manager" ../scripts/k8s-wait-deployment.sh
