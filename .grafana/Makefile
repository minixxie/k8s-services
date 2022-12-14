# Dashboards
# *https://grafana.com/grafana/dashboards/12062-node-exporter/
# https://grafana.com/grafana/dashboards/16378-node-exporter-nodes/

CHOICE := 1  # 1: grafana + prometheus, 2: grafana + mimir

.PHONY: up
up:
	helm repo add grafana https://grafana.github.io/helm-charts || true
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts || true
	helm repo list
	helm repo update
	# prometheus
	helm upgrade --install prometheus prometheus-community/prometheus -n tools --create-namespace
	kubectl get deployment -n tools | grep prometheus
	# mimir
	if [ "${CHOICE}" == 2 ]; then \
		helm upgrade --install mimir grafana/mimir-distributed -f ./mimir.custom.yaml -n tools --create-namespace; \
		kubectl get deployment -n tools | grep mimir; \
	fi
	# loki
	helm upgrade --install loki grafana/loki-stack -n tools --create-namespace
	# grafana-agent
	helm upgrade --install grafana-agent grafana/grafana-agent-operator -n tools --create-namespace
	kubectl get deployment grafana-agent-grafana-agent-operator -n tools
	# grafana
	helm upgrade --install grafana grafana/grafana -n tools --create-namespace
	kubectl get deployment grafana -n tools
	# See what releases were deployed
	helm list -n tools
	kubectl apply -f prometheus.ingress.yaml
	kubectl apply -f grafana.ingress.yaml
	kubectl apply -f metrics.metricsinstance.yaml
	@echo "Add data source on grafana: http://grafana.minikube/datasources/new"
	@echo "[Prometheus]"
	@echo "1. Choose 'Prometheus'"
	@echo "2. Input HTTP URL as http://prometheus-server.tools.svc:80 (prometheus-server is the k8s svc name)"
	@echo "3. Save & test"
	@echo "[Prometheus (Mimir)]"
	@echo "1. Choose 'Prometheus'"
	@echo "2. Input HTTP URL as http://mimir-nginx.tools.svc:80/prometheus (mimir-nginx is the k8s svc name)"
	@echo "3. Save & test"
	@echo "[Loki]"
	@echo "1. Choose 'Loki'"
	@echo "2. Input HTTP URL as http://loki.tools.svc:3100 (loki is the k8s svc name)"
	@echo "3. Save & test"

.PHONY: down
down:
	kubectl delete ing grafana -n tools || true
	kubectl delete ing prometheus -n tools || true
	kubectl delete metricsinstance metrics -n tools || true
	helm uninstall grafana -n tools || true
	helm uninstall grafana-agent -n tools || true
	helm uninstall loki -n tools || true
	helm uninstall mimir -n tools || true
	helm uninstall prometheus -n tools || true
