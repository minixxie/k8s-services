.PHONY: up
up:
	helm dep update .
	helm upgrade --install postgresql . -n db --create-namespace

.PHONY: down
down:
	helm uninstall postgresql -n db || true
	# https://stackoverflow.com/questions/63917524/helm-postgres-password-authentication-failed
	#kubectl -n db delete pvc $$(kubectl get pvc -n db | grep postgres | awk '{print $$1}') || true

.PHONY: cli
cli:
	kubectl run postgresql-client --rm --tty -i --restart='Never' --namespace db --image docker.io/bitnami/postgresql:15.1.0-debian-11-r0 --env=PGPASSWORD=$$(kubectl get secret --namespace db postgresql -o jsonpath="{.data.postgres-password}" | base64 -d) --command -- psql --host postgresql -U postgres -d postgres -p 5432
