DOCKER ?= nerdctl
BUILDOPS ?= --namespace=k8s.io

IMG := go-kafka-client-app:dont_push
GOLANG_IMG := minixxie/golang:1.21.0

.PHONY: get
get:
	${DOCKER} images ${BUILDOPS} | grep go-kafka-client-app
	kubectl get all -l appID=go-kafka-client-app

.PHONY: build
build:
	${DOCKER} build ${BUILDOPS} -t ${IMG} .

.PHONY: up
up:
	cd kustomization/base && kubectl apply -k . && cd -

.PHONY: down
down:
	cd kustomization/base && kubectl delete -k . && cd -

.PHONY: logs
logs:
	kubectl logs -f -l appID=go-kafka-client-app

.PHONY: sh
sh:
	${DOCKER} run --rm -it -v "${PWD}:/go/src/app" -w "/go/src/app" \
		"${GOLANG_IMG}" bash

gofmt:
	${DOCKER} run --rm -t -v "${PWD}:/go/src/app" -w "/go/src/app" "${GOLANG_IMG}" gofmt -w .
