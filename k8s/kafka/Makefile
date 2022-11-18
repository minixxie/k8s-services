.PHONY: check
check:
	kubectl get statefulset kafka -n middleware
	kubectl get svc kafka -n middleware
	kubectl get svc kafka-headless -n middleware
	kubectl get svc kafka-zookeeper -n middleware
	kubectl get svc kafka-zookeeper-headless -n middleware

.PHONY: up
up:
	helm repo add bitnami https://charts.bitnami.com/bitnami || true
	helm upgrade --install kafka bitnami/kafka -n middleware --create-namespace

.PHONY: down
down:
	helm uninstall kafka -n middleware || true
