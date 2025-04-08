# https://kubevirt.io/quickstart_cloud/

SHELL := /bin/bash

.PHONY: ns
ns:
	echo kubevirt

.PHONY: get
get:
	kubectl -n kubevirt get all
	kubectl -n kubevirt get ing

.PHONY: up
up:
	VERSION=$$(curl -s https://storage.googleapis.com/kubevirt-prow/release/kubevirt/kubevirt/stable.txt); \
	echo $$VERSION; \
	kubectl create -f "https://github.com/kubevirt/kubevirt/releases/download/$$VERSION/kubevirt-operator.yaml" || true; \
	kubectl create -f "https://github.com/kubevirt/kubevirt/releases/download/$$VERSION/kubevirt-cr.yaml" || true
	export VERSION=$$(curl -s https://api.github.com/repos/kubevirt/containerized-data-importer/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/'); \
	kubectl create -f https://github.com/kubevirt/containerized-data-importer/releases/download/$$VERSION/cdi-operator.yaml || true; \
	kubectl create -f https://github.com/kubevirt/containerized-data-importer/releases/download/$$VERSION/cdi-cr.yaml || true
	make -s virtctl
	#./add-user-to-kvm.sh
	#sudo systemctl restart k3s

.PHONY: local
local: up

# https://kubevirt.io/quickstart_cloud/
.PHONY: virtctl
virtctl:
	echo "make virtctl..."
	make -s wait
	./install-virtctl.sh

.PHONY: wait
wait:
	NS=kubevirt DEPLOYMENT="virt-operator" ../scripts/k8s-wait-deployment.sh
	NS=kubevirt DEPLOYMENT="virt-api" ../scripts/k8s-wait-deployment.sh
	NS=kubevirt DEPLOYMENT="virt-controller" ../scripts/k8s-wait-deployment.sh
	NS=kubevirt LABELS="app.kubernetes.io/component=kubevirt" ../scripts/k8s-wait-daemonset.sh
	NS=cdi DEPLOYMENT="cdi-operator" ../scripts/k8s-wait-deployment.sh

.PHONY: img
img:

.PHONY: test
test:
	#cd .. && make -s -C ubuntu-vm
	#kubectl delete -f vm.yaml || true
	#kubectl apply -f vm.yaml
	#kubectl -n kubevirt get vms
	#kubectl -n kubevirt wait --for=condition=Ready vm/ubuntu-vm --timeout=120s
