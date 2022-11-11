.PHONY: up
up:
	helm repo add bitnami https://charts.binami.com/bitnami || true
	helm repo list
	helm repo update
	helm upgrade --install mysql bitnami/mysql -n db --create-namespace

.PHONY: down
down:
	helm uninstall mysql -n db || true
