.PHONY: check
check:
	helm list -n db | grep redis-cluster-01 || true

.PHONY: up
up:
	helm dep update .
	helm upgrade --install redis-cluster-01 . -n db --create-namespace

.PHONY: down
down:
	helm uninstall redis-cluster-01 -n db || true

.PHONY: cli
cli:
	@pass=$$(kubectl get secret redis-cluster -n db -o go-template='{{index .data "redis-password" | base64decode}}'); \
		echo "redis-cli -c -h redis-redis-cluster.db.svc -p 6379 -a $$pass"; \
	kubectl run redis-cli --rm --tty -i --restart='Never' --image docker.io/bitnami/redis-cluster:7.0.5-debian-11-r19 -n db --command -- bash
