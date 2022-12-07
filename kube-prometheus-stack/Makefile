.PHONY: check
check:

.PHONY: up
up:
	helm dep update .
	helm upgrade --install kube-prometheus-stack . -n monitor --create-namespace

.PHONY: down
down:
	helm uninstall kube-prometheus-stack -n monitor || true
