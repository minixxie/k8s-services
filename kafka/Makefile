.PHONY: up
up:
	helm dep update .
	helm upgrade --install kafka . -n kafka --create-namespace

.PHONY: down
down:
	helm uninstall kafka -n kafka || true
