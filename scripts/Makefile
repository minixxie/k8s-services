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
	# kubectl -n $$(make -s ns) get all
	@kubectl -n $$(make -s ns) get all
	@echo "----------------------------------------"
	# kubectl -n $$(make -s ns) get ing
	@kubectl -n $$(make -s ns) get ing
	@echo "----------------------------------------"
	# kubectl -n $$(make -s ns) get pvc
	@kubectl -n $$(make -s ns) get pvc
	@echo "----------------------------------------"
	# kubectl get pv
	@kubectl get pv
	@echo "----------------------------------------"
	@if [ -f get.rc ]; then source get.rc; fi

.PHONY: up
up: imp-img
	if [ -f Chart.yaml ]; then \
		helm dep update .; \
		helm upgrade --install --wait $$(make -s chart-name) . -n $$(make -s ns) --create-namespace; \
	elif [ -d kustomize ]; then \
		cd kustomize/ ; kubectl apply -k . ; \
	fi

# values.yaml used as default, values.local.yaml as override
.PHONY: local
local: imp-img
	if [ -f local.rc ]; then \
		source local.rc; \
	else \
		if [ -f Chart.yaml ]; then \
			helm dep update .; \
			helm upgrade --install --wait $$(make -s chart-name) . -n $$(make -s ns) --create-namespace -f values.local.yaml; \
		elif [ -d kustomize ]; then \
			kubectl apply -k overlays/local ; \
		fi; \
	fi

.PHONY: down
down:
	if [ -f Chart.yaml ]; then \
		helm uninstall $$(make -s chart-name) -n $$(make -s ns) || true; \
	elif [ -d kustomize ]; then \
		cd kustomize/ ; kubectl delete -k . ; \
	fi

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
		if [ $$? -ne 0 ]; then \
			nerdctl pull "$$IMG:$$IMG_TAG" --namespace=k8s.io; \
		fi; \
		f=$$(echo $$IMG | sed 's/\//__/g'); \
		nerdctl save $$IMG:$$IMG_TAG --output "$$f"___"$$IMG_TAG.tar" --namespace=k8s.io; \
		ls -lt "$$f"___"$$IMG_TAG.tar"; \
	fi

.PHONY: imp-img
imp-img:
	if [ -f img.rc ]; then \
		source img.rc; \
		f=$$(echo $$IMG | sed 's/\//__/g'); \
		if [ -f "$$f"___"$$IMG_TAG.tar" ]; then \
			nerdctl --namespace=k8s.io images | grep $$IMG | grep $$IMG_TAG; \
			if [ $$? -ne 0 ]; then \
				nerdctl load -i "$$f"___"$$IMG_TAG.tar" --namespace=k8s.io; \
			fi; \
		else \
			echo >&2 "WARN: file not exists: $$f"___"$$IMG_TAG.tar"; \
			nerdctl pull "$$IMG:$$IMG_TAG" --namespace=k8s.io; \
			make -s exp-img; \
		fi; \
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
