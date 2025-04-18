SHELL := /bin/bash

.PHONY: helm-repo
helm-repo:
	@if [ -x ./helm-repo ]; then ./helm-repo; else ../scripts/helm-repo; fi

.PHONY: helm-repo-alias
helm-repo-alias:
	@source make.rc ; echo $$HELM_REPO_ALIAS

.PHONY: chart-name
chart-name:
	@if [ -x ./chart-name ]; then ./chart-name; else ../scripts/chart-name; fi

.PHONY: ns
ns:
	@if [ -x ./ns ]; then ./ns; else ../scripts/ns; fi

.PHONY: check
check:
	helm list -n $(shell make -s --no-print-directory ns) -f $(shell make -s --no-print-directory chart-name) || true


.PHONY: get
get:
	@if [ -x ./get ]; then ./get; else ../scripts/get; fi

.PHONY: top
top:
	@if [ -x ./top ]; then ./top; else ../scripts/top; fi

.PHONY: logs
logs:
	@if [ -x ./logs ]; then ./logs; else ../scripts/logs; fi

.PHONY: desc
desc:
	@if [ -x ./desc ]; then ./desc; else ../scripts/desc; fi

.PHONY: exec
exec:
	@if [ -x ./exec ]; then ./exec; else ../scripts/exec; fi

.PHONY: up
up:
	@if [ -x ./up ]; then ./up; else ../scripts/up; fi

# values.yaml used as default, values.local.yaml as override
.PHONY: local
local: img
	@if [ -x ./local ]; then ./local; else ../scripts/local; fi

.PHONY: down
down:
	@if [ -x ./down ]; then ./down; else ../scripts/down; fi

.PHONY: cli
cli:
	@./cli

.PHONY: test
test:
	@if [ -x ./test ]; then ./test; else ../scripts/test; fi

.PHONY: img
img:
	@if [ -x ./img ]; then ./img; else ../scripts/img; fi

.PHONY: helm-repo-add
helm-repo-add:
	@if [ -x ./helm-repo-add ]; then ./helm-repo-add; else ../scripts/helm-repo-add; fi

.PHONY: helm-repo-remove
helm-repo-remove:
	@if [ -x ./helm-repo-remove ]; then ./helm-repo-remove; else ../scripts/helm-repo-remove; fi

.PHONY: helm-repo-search
helm-repo-search: helm-repo-add
	helm search repo $(shell make -s --no-print-directory helm-repo-alias)

.PHONY: helm-show-val
helm-show-val:
	@if [ -x ./helm-show-val ]; then ./helm-show-val; else ../scripts/helm-show-val; fi

.PHONY: tpl
tpl: helm-repo-add
	helm template $(shell make -s --no-print-directory chart-name) $(shell make -s --no-print-directory helm-repo-alias)/$(shell make -s --no-print-directory chart-name)

.PHONY: wait
wait:
	@if [ -x ./wait ]; then ./wait; else ../scripts/wait; fi
