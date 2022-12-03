.PHONY: check
check:
	kubectl get pod -n argo-cd
	@argocdPwd=$$(kubectl get -n argo-cd secret argocd-initial-admin-secret -o go-template='{{.data.password | base64decode}}' ; echo); \
		echo "URL: http://argo-cd.local/" ; \
		echo "user: admin"; echo "pass: $$argocdPwd"

.PHONY: up
up:
	helm repo add argo-cd https://argoproj.github.io/argo-helm
	helm dep update .
	helm upgrade --install argo-cd . -n argo-cd --create-namespace

.PHONY: down
down:
	helm uninstall argo-cd -n argo-cd || true
	kubectl delete crd applications.argoproj.io || true
	kubectl delete crd applicationsets.argoproj.io || true
	kubectl delete crd appprojects.argoproj.io || true
