.PHONY: check
check:
	helm list -n db | grep mysql || true

.PHONY: up
up:
	helm dep update .
	helm upgrade --install mysql . -n db --create-namespace

.PHONY: down
down:
	helm uninstall mysql -n db || true

.PHONY: cli
cli:
	kubectl run mysql-client --rm --tty -i --restart='Never' --image docker.io/bitnami/mysql:8.0.31-debian-11-r10 --namespace db --env MYSQL_ROOT_PASSWORD=$$(kubectl get secret --namespace db mysql -o jsonpath="{.data.mysql-root-password}" | base64 -d) --command -- bash -c 'mysql -h mysql.db.svc.cluster.local -uroot -p"$$MYSQL_ROOT_PASSWORD"'
