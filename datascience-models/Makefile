.PHONY: get
get:
	kubectl get pv datascience-models
	kubectl get pvc datascience-models
	kubectl get pod/datascience-models

.PHONY: up
up:
	kubectl apply -k .
	kubectl -n default wait --for condition=ready --timeout=10m pod datascience-models
	./cp-files.sh

.PHONY: down
down:
	kubectl delete -k .

.PHONY: exec
exec:
	kubectl exec -it pod/datascience-models -- sh
