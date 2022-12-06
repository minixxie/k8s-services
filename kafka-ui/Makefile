.PHONY: check
check:

.PHONY: up
up:
	helm dep update .
	helm upgrade --install kafka-ui . -n kafka --create-namespace

.PHONY: down
down:
	helm uninstall kafka-ui -n kafka || true
