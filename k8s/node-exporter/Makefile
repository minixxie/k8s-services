.PHONY: up
up:
	helm repo add bitnami https://charts.bitnami.com/bitnami || true
	helm repo update || true
	helm upgrade --install node-exporter bitnami/node-exporter || true

.PHONY: down
down:
	helm uninstall node-exporter
