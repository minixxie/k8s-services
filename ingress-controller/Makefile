.PHONY: check
check:
	helm list | grep traefik || true

.PHONY: up
up:
	helm dep update .
	make -s down
	helm upgrade --install traefik .

.PHONY: local
local: up

.PHONY: down
down:
	helm uninstall traefik || true

.PHONY: wait
wait:
	NS=default DEPLOYMENT="traefik" ../scripts/k8s-wait-deployment.sh
