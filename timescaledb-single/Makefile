.PHONY: check
check:
	helm list -n timescaledb-single | grep timescaledb || true

.PHONY: up
up:
	helm dep update .
	helm upgrade --install timescaledb-single . -n timescaledb --create-namespace

.PHONY: down
down:
	helm uninstall timescaledb-single -n timescaledb || true
