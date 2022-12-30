.PHONY: check
check:

.PHONY: up
up:
	helm dep update .
	helm upgrade --install signoz . -n signoz --create-namespace

.PHONY: down
down:
	helm uninstall signoz -n signoz || true
