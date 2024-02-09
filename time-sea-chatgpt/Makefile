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
	kubectl -n time-sea-chatgpt get all  ##########################################
	kubectl -n time-sea-chatgpt get cm  ##########################################
	kubectl -n time-sea-chatgpt get ing  ##########################################
	kubectl -n time-sea-chatgpt get pvc  ##########################################
	kubectl get pv   ##########################################

.PHONY: top
top:
	kubectl -n time-sea-chatgpt top pod -l appID=time-sea-chatgpt
	kubectl -n time-sea-chatgpt top pod -l appID=time-sea-chatgpt-web

.PHONY: wait
wait:
	NS=time-sea-chatgpt DEPLOYMENT="time-sea-chatgpt" ../scripts/k8s-wait-deployment.sh
	NS=time-sea-chatgpt DEPLOYMENT="time-sea-chatgpt-web" ../scripts/k8s-wait-deployment.sh
