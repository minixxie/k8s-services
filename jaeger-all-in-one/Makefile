.PHONY: check
check:

.PHONY: up
up:
	helm dep update .
	helm upgrade --install jaeger-all-in-one . -n jaeger --create-namespace

.PHONY: down
down:
	helm uninstall jaeger-all-in-one -n jaeger || true
