.PHONY: check
check:

.PHONY: up
up:
	helm dep update .
	helm upgrade --install opentelemetry-collector . -n otel --create-namespace

.PHONY: down
down:
	helm uninstall opentelemetry-collector -n otel || true
