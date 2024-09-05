# https://operatorhub.io/operator/cert-manager

SHELL := /bin/bash

.PHONY: get 
ls:
	kubectl -n operators get csv -l operators.coreos.com/cert-manager.operators=
	kubectl -n operators get subscription -l operators.coreos.com/cert-manager.operators=
	#kubectl -n operators get all -l app=cert-manager
	kubectl -n operators get all -l app.kubernetes.io/name=cert-manager

.PHONY: up
up:
	kubectl apply -f https://operatorhub.io/install/cert-manager.yaml

.PHONY: local
local: up

.PHONY: wait
wait:
	NS=operators DEPLOYMENT="cert-manager-webhook" ../scripts/k8s-wait-deployment.sh
	NS=operators DEPLOYMENT="cert-manager-cainjector" ../scripts/k8s-wait-deployment.sh
	NS=operators DEPLOYMENT="cert-manager" ../scripts/k8s-wait-deployment.sh
