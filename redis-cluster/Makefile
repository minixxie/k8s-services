.PHONY: check
check:
	helm list -n db | grep redis || true

.PHONY: up
up:
	helm dep update .
	helm upgrade --install redis . -n db --create-namespace

.PHONY: down
down:
	helm uninstall redis -n db || true

.PHONY: cli
cli:
