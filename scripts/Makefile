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
	helm repo list


.PHONY: ps
ps:
	kubectl -n $$(make -s ns) get all
	kubectl -n $$(make -s ns) get ing

.PHONY: up
up:
	helm dep update .
	helm upgrade --install $$(make -s chart-name) . -n $$(make -s ns) --create-namespace

.PHONY: local
local:
	helm dep update .
	helm upgrade --install $$(make -s chart-name) . -n $$(make -s ns) --create-namespace -f values.local.yaml  # values.yaml used as default, values.local.yaml as override

.PHONY: down
down:
	helm uninstall $$(make -s chart-name) -n $$(make -s ns) || true

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
