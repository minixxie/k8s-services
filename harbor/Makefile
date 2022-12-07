.PHONY: check
check:


.PHONY: up
up:
	helm dep update .
	helm upgrade --install harbor . -n harbor --create-namespace

.PHONY: down
down:
	helm uninstall harbor -n harbor
