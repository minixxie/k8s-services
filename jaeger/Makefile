.PHONY: check
check:

.PHONY: up
up:
	helm dep update .
	helm upgrade --install jaeger . -n monitor --create-namespace

.PHONY: down
down:
	helm uninstall jaeger -n monitor || true
