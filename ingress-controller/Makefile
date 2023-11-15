.PHONY: check
check:
	helm list | grep traefik || true

.PHONY: up
up:
	helm dep update .
	make -s down
	helm upgrade --install traefik .

.PHONY: down
down:
	helm uninstall traefik || true
