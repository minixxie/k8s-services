.PHONY: check
check:
	helm list -n db | grep redisinsight || true

.PHONY: up
up:
	helm dep update .
	helm upgrade --install redisinsight . -n db --create-namespace

.PHONY: down
down:
	helm uninstall redisinsight -n db || true
