SHELL := /bin/bash
APP := infra-apollo

.PHONY: build
build:
	nerdctl build . -t local/${APP}-mysql-db:dont_push --namespace=k8s.io

.PHONY: get
get:
	kubectl -n infra-mysql get all -l app=${APP}

.PHONY: up
up: build
	kubectl delete -k ./kustomization/base/ || true
	kubectl apply -k ./kustomization/base/

.PHONY: down
down:
	kubectl delete -k ./kustomization/base/ || true

.PHONY: logs
logs:
	kubectl -n infra-mysql logs -f $$(kubectl -n infra-mysql get pod -l app=${APP} | sed 1d | awk '{print $$1}')

.PHONY: wait
wait:
	kubectl -n infra-mysql wait --for=condition=complete job/infra-apollo-mysql-db --timeout=300s

.PHONY: clean
clean:
	./clean

.PHONY: cli
cli:
	./cli
