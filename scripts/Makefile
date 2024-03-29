SHELL := /bin/bash

.PHONY: helm-repo
helm-repo:
	@cat Chart.yaml | grep repository | sed 's/^.*: //'

.PHONY: helm-repo-alias
helm-repo-alias:
	@source make.rc ; echo $$HELM_REPO_ALIAS

.PHONY: chart-name
chart-name:
	@cat Chart.yaml | grep "^name: " | sed 's/^name: //'

.PHONY: ns
ns:
	@source make.rc ; echo $$NAMESPACE

.PHONY: check
check:
	helm list -n $$(make -s ns) -f $$(make -s chart-name) || true


.PHONY: get
get:
	@echo "----------------------------------------"
	kubectl -n $$(make -s ns) get all
	@echo "----------------------------------------"
	kubectl -n $$(make -s ns) get ing
	@echo "----------------------------------------"
	kubectl -n $$(make -s ns) get pvc
	@echo "----------------------------------------"
	kubectl get pv
	@echo "----------------------------------------"
	if [ -f get.rc ]; then source get.rc; fi

.PHONY: up
up:
	helm dep update .
	helm upgrade --install $$(make -s chart-name) . -n $$(make -s ns) --create-namespace

# values.yaml used as default, values.local.yaml as override
.PHONY: local
local:
	if [ -f local.rc ]; then \
		source local.rc; \
	else \
		helm dep update .; \
		helm upgrade --install $$(make -s chart-name) . -n $$(make -s ns) --create-namespace -f values.local.yaml; \
	fi

.PHONY: down
down:
	helm uninstall $$(make -s chart-name) -n $$(make -s ns) || true

.PHONY: cli
cli:
	if [ -f cli.rc ]; then source cli.rc; fi

.PHONY: test
test:
	if [ -x test.sh ]; then ./test.sh; fi

.PHONY: exp-img
exp-img:
	if [ -f img.rc ]; then \
		source img.rc; \
		nerdctl --namespace=k8s.io images | grep $$IMG | grep $$IMG_TAG; \
		f=$$(echo $$IMG | sed 's/\//__/g'); \
		nerdctl save $$IMG:$$IMG_TAG --output "$$f"___"$$IMG_TAG.tar" --namespace=k8s.io; \
		ls -lt "$$f"___"$$IMG_TAG.tar"; \
	fi

.PHONY: imp-img
imp-img:
	if [ -f img.rc ]; then \
		source img.rc; \
		f=$$(echo $$IMG | sed 's/\//__/g'); \
		nerdctl load -i "$$f"___"$$IMG_TAG.tar" --namespace=k8s.io; \
		nerdctl --namespace=k8s.io images | grep $$IMG | grep $$IMG_TAG; \
	fi

.PHONY: repo-add
repo-add:
	helm repo add $$(make -s helm-repo-alias) $$(make -s helm-repo)

.PHONY: repo-remove
repo-remove:
	helm repo remove $$(make -s helm-repo-alias) || true

.PHONY: repo-search
repo-search: repo-add
	helm search repo $$(make -s helm-repo-alias)

.PHONY: show-val
show-val: repo-add
	helm show values $$(make -s helm-repo-alias)/$$(make -s chart-name)

.PHONY: tpl
tpl: repo-add
	helm template $$(make -s chart-name) $$(make -s helm-repo-alias)/$$(make -s chart-name)

.PHONY: wait
wait:
	@if [ -f wait.rc ]; then \
		source make.rc ; NS=$$NAMESPACE source wait.rc; \
	else \
		source make.rc ; NS=$$NAMESPACE DEPLOYMENT="$$DEPLOYMENT" ../scripts/k8s-wait-deployment.sh; \
	fi
