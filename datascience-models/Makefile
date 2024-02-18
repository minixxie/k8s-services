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

.PHONY: local
local: up

.PHONY: down
down:
	kubectl delete -k .

.PHONY: wait
wait:
	# NOOP

.PHONY: exec
exec:
	kubectl exec -it pod/datascience-models -- sh -c 'cd /datascience-models && sh'

.PHONY: test
test:
	./test.sh
