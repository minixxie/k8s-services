.PHONY: check
check:
	kubectl get ingress prometheus-mysql-exporter -n infra-mysql
	kubectl get pod -l app.kubernetes.io/name=prometheus-mysql-exporter -n infra-mysql
	kubectl get svc prometheus-mysql-exporter -n infra-mysql
	kubectl get deploy prometheus-mysql-exporter -n infra-mysql

.PHONY: up
up:
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts || true
	helm repo list
	helm repo update
	# if ServiceMonitor resource exists and MySQL statefulset was deployed:
	if [ "$$(kubectl get servicemonitor -A)" != "error: the server doesn't have a resource type \"servicemonitor\"" ]; then \
		kubectl get statefulset mysql -n infra-mysql ; \
		if [ $$? -eq 0 ]; then \
			helm upgrade --install prometheus-mysql-exporter prometheus-community/prometheus-mysql-exporter \
				-f ./prometheus-mysql-exporter.values.yaml -n infra-mysql --create-namespace; \
			kubectl apply -f ./prometheus-mysql-exporter.ingress.yaml; \
		fi; \
	fi

.PHONY: down
down:
	kubectl delete -f ./prometheus-mysql-exporter.ingress.yaml || true
	helm uninstall prometheus-mysql-exporter -n infra-mysql || true

