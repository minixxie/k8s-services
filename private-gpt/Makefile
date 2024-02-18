.PHONY: up
up:
	kubectl apply -k .

.PHONY: local
local: up

.PHONY: down
down:
	kubectl delete -k .

.PHONY: get
get:
	kubectl -n private-gpt get all  ##########################################
	kubectl -n private-gpt get cm  ##########################################
	kubectl -n private-gpt get ing  ##########################################
	kubectl -n private-gpt get pvc  ##########################################
	kubectl get pv   ##########################################

.PHONY: top
top:
	kubectl -n private-gpt top pod -l appID=private-gpt
	kubectl -n private-gpt top pod -l appID=private-gpt-web

.PHONY: wait
wait:
	NS=private-gpt DEPLOYMENT="private-gpt" ../scripts/k8s-wait-deployment.sh
	NS=private-gpt DEPLOYMENT="private-gpt-web" ../scripts/k8s-wait-deployment.sh

.PHONY: test
test:
	./test.sh
