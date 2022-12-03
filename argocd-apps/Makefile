.PHONY: up
up:
	helm dep update .
	helm upgrade --install argocd-apps . -n argo-cd --create-namespace

.PHONY: down
down:
	helm uninstall argocd-apps -n argo-cd || true
