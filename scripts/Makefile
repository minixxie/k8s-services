SHELL := /bin/bash

.PHONY: helm-repo
helm-repo:
	@./helm-repo

.PHONY: helm-repo-alias
helm-repo-alias:
	@source make.rc ; echo $$HELM_REPO_ALIAS

.PHONY: chart-name
chart-name:
	@./chart-name

.PHONY: ns
ns:
	@./ns

.PHONY: check
check:
	helm list -n $$(make -s ns) -f $$(make -s chart-name) || true


.PHONY: get
get:
	@./get

.PHONY: up
up:
	@./up

# values.yaml used as default, values.local.yaml as override
.PHONY: local
local:
	@./local

.PHONY: down
down:
	@./down

.PHONY: cli
cli:
	@./cli

.PHONY: test
test:
	if [ -x test.sh ]; then ./test.sh; fi
	if [ -x test ]; then ./test; fi

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
	@./helm-repo-add

.PHONY: repo-remove
repo-remove:
	@./helm-repo-remove

.PHONY: repo-search
repo-search: repo-add
	helm search repo $$(make -s helm-repo-alias)

.PHONY: show-val
show-val:
	@./helm-show-val

.PHONY: tpl
tpl: repo-add
	helm template $$(make -s chart-name) $$(make -s helm-repo-alias)/$$(make -s chart-name)

.PHONY: wait
wait:
	@./wait
