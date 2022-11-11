.PHONY: up
up:
	helm repo add bitnami https://charts.binami.com/bitnami || true
	helm repo list
	helm repo update
	helm upgrade --install postgresql bitnami/postgresql -n db --create-namespace

.PHONY: down
down:
	helm uninstall postgresql -n db || true

.PHONY: cli
cli:
	kubectl run postgresql-client --rm --tty -i --restart='Never' --namespace db --image docker.io/bitnami/postgresql:11.13.0-debian-10-r0 --env="PGPASSWORD=$$(kubectl get secret --namespace db postgresql -o jsonpath="{.data.postgresql-password}" | base64 --decode)" --command -- psql --host postgresql -U postgres -d postgres -p 5432
