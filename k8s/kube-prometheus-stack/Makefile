.PHONY: check
check:

.PHONY: up
up:
	helm repo add prometheus-community https://prometheus-community.github.io/helm-charts || true
	helm repo update || true
	helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack -n monitor --create-namespace || true
	kubectl apply -f ./prometheus.ingress.yaml
	kubectl apply -f ./grafana.ingress.yaml

.PHONY: down
down:
	kubectl delete ing prometheus -n monitor || true
	kubectl delete ing grafana -n monitor || true
	helm uninstall kube-prometheus-stack -n monitor || true
