.PHONY: check
check:

.PHONY: up
up:
	helm dep update .
	helm upgrade --install zipkin . -n zipkin --create-namespace

.PHONY: down
down:
	helm uninstall zipkin -n zipkin || true
