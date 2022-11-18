.PHONY: check
check:
	helm list -n db | grep mysql || true

.PHONY: up
up:
	helm repo add bitnami https://charts.binami.com/bitnami || true
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts || true
	helm repo list
	helm repo update
	helm upgrade --install mysql bitnami/mysql -n db --create-namespace
	if [ "$$(kubectl get servicemonitor -A)" != "error: the server doesn't have a resource type \"servicemonitor\"" ]; then \
		helm upgrade --install prometheus-mysql-exporter prometheus-community/prometheus-mysql-exporter \
		-f ./prometheus-mysql-exporter.values.yaml -n db --create-namespace; \
		kubectl apply -f ./prometheus-mysql-exporter.ingress.yaml; \
	fi

.PHONY: down
down:
	kubectl delete -f ./prometheus-mysql-exporter.ingress.yaml
	helm uninstall prometheus-mysql-exporter -n db || true
	helm uninstall mysql -n db || true

.PHONY: cli
cli:
	kubectl run mysql-client --rm --tty -i --restart='Never' --image docker.io/bitnami/mysql:8.0.31-debian-11-r10 --namespace db --env MYSQL_ROOT_PASSWORD=$$(kubectl get secret --namespace db mysql -o jsonpath="{.data.mysql-root-password}" | base64 -d) --command -- bash -c 'mysql -h mysql.db.svc.cluster.local -uroot -p"$$MYSQL_ROOT_PASSWORD"'
