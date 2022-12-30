.PHONY: check
check:

.PHONY: up
up:
	helm dep update .
	helm upgrade --install zipkin-aws . -n zipkin --create-namespace

.PHONY: down
down:
	helm uninstall zipkin-aws -n zipkin || true
