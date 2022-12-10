.PHONY: up
up:
	helm dep update .
	helm upgrade --install pgamin4 . -n db --create-namespace

.PHONY: down
down:
	helm uninstall pgadmin4 -n db || true
