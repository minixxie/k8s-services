.PHONY: build
build:
	nerdctl build . -t static-web:dont_push --namespace=k8s.io

.PHONY: up
up:
	cd k8s && kubectl apply -k . && cd -

.PHONY: down
down:
	cd k8s && kubectl delete -k . && cd -
