.PHONY: up
up:
	kubectl apply -k .

.PHONY: down
down:
	kubectl delete -k .

.PHONY: get
get:
	kubectl -n private-gpt get all
	kubectl -n private-gpt get ing
	kubectl -n private-gpt get pvc
	kubectl -n private-gpt get pv

.PHONY: top
top:
	kubectl -n private-gpt top pod -l appID=private-gpt
