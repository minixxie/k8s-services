.PHONY: check
check:

.PHONY: up
up:
	helm repo add kafka-ui https://provectus.github.io/kafka-ui || true
	helm upgrade --install kafka-ui kafka-ui/kafka-ui -n middleware --create-namespace \
		--set envs.config.KAFKA_CLUSTERS_0_NAME=local \
		--set envs.config.KAFKA_CLUSTERS_0_BOOTSTRAPSERVERS=kafka:9092

.PHONY: down
down:
	helm uninstall kafka-ui -n middleware || true
