SHELL := /bin/bash

.PHONY: check
check:
	kubectl get node
	kubectl config get-clusters
	kubectl config current-context
	kubectl get namespace
	kubectl get all -A

.PHONY: ncpu
ncpu:
	@if [ "$$(uname -s)" == "Darwin" ]; then \
		sysctl hw.ncpu | sed 's/.*: //'; \
	elif [ "$$(uname -s)" == "Linux" ]; then \
		echo 0; \
	else \
		echo 0; \
	fi

.PHONY: mem
mem:
	@if [ "$$(uname -s)" == "Darwin" ]; then \
		expr $$(sysctl hw.memsize | sed 's/.*: //') / 1024 / 1024 / 1024; \
	elif [ "$$(uname -s)" == "Linux" ]; then \
		echo 0; \
	else \
		echo 0; \
	fi

.PHONY: colima-small
colima-small:
	colima start -k --runtime containerd \
		--cpu $$(expr $$(make -s ncpu) / 4) \
		--memory $$(expr $$(make -s mem) / 4) \
		--disk 20 \
		-p small
	make -s -C ./ingress-controller local wait

.PHONY: colima
colima:
	colima start -k --runtime containerd \
		--cpu $$(expr $$(make -s ncpu) / 2) \
		--memory $$(expr $$(make -s mem) / 2) \
		--disk 100
	make -s -C ./ingress-controller local wait

.PHONY: colima-amd64
colima-amd64:
	colima start -k --runtime containerd \
		--cpu $$(expr $$(make -s ncpu) / 2) \
		--memory $$(expr $$(make -s mem) / 2) \
		--disk 100 \
		--arch amd64 --vm-type=vz --vz-rosetta
	make -s -C ./ingress-controller local wait

.PHONY: colima-aarch64
colima-aarch64:
	colima start -k --runtime containerd \
		--cpu $$(expr $$(make -s ncpu) / 2) \
		--memory $$(expr $$(make -s mem) / 2) \
		--disk 100 \
		--arch aarch64 --vm-type=vz --vz-rosetta
	make -s -C ./ingress-controller local wait

.PHONY: install-docker
install-docker:
	./scripts/install-docker.sh

.PHONY: uninstall-docker
uninstall-docker:
	./scripts/uninstall-docker.sh

.PHONY: k8s-redo
k8s-redo:
	sys=$$(uname -s); echo $$sys; \
	if [ "$$sys" == "Darwin" ]; then \
		colima stop --force; \
		colima delete --force; \
		make -s colima; \
	else \
		make -s k3s-redo; \
	fi

.PHONY: k3s
k3s:
	sudo ./scripts/k3s.sh
	sudo ./scripts/nerdctl.sh
	sudo ./scripts/buildkit.sh
	make -s k3s-wait
	make -s -C coredns local

.PHONY: k3s-redo
k3s-redo:
	sudo k3s-uninstall.sh || true
	sudo ./scripts/k3s.sh
	#sudo systemctl stop k3s
	#sudo rm -rf /var/lib/rancher/k3s
	#sudo systemctl start k3s
	make -s k3s-wait
	#make -s -C coredns local

.PHONY: k3s-wait
k3s-wait:
	NS=kube-system DEPLOYMENT=coredns ./scripts/k8s-wait-deployment.sh
	NS=kube-system DEPLOYMENT=local-path-provisioner ./scripts/k8s-wait-deployment.sh
	NS=kube-system DEPLOYMENT=metrics-server ./scripts/k8s-wait-deployment.sh
	NS=kube-system DEPLOYMENT=traefik ./scripts/k8s-wait-deployment.sh
	NS=kube-system LABELS="svccontroller.k3s.cattle.io/svcname=traefik" ./scripts/k8s-wait-daemonset.sh

.PHONY: index
index:
	./bin/gen-index-html.sh

.PHONY: kubeapps
kubeapps:
	make -s -C ./kubeapps up

.PHONY: mysql
mysql:
	make -s -C ./infra-mysql@8.2.0 up \
		&& make -s mysql-exporter

.PHONY: mysql-exporter
mysql-exporter:
	make -s -C ./prometheus-mysql-exporter up

.PHONY: xxl-job
xxl-job:
	make -s -C ./xxl-job local

.PHONY: kube-prometheus-stack
kube-prometheus-stack:
	make -s -C ./kube-prometheus-stack up \
		&& make -s mysql-exporter

.PHONY: kafka
kafka:
	make -s -C ./kafka up \
		&& make -s -C ./kafka-ui up

.PHONY: ragflow
ragflow:
	make -s -C ./nvidia-gpu-operator img local wait test \
		&& make -s -C ./infra-mysql@8.2.0 img local wait test \
		&& make -s -C ./infra-elasticsearch@8.13.2 img local wait test \
		&& make -s -C ./ai-ragflow img local wait test

.PHONY: ingress-controller
ingress-controller:
	make -s -C ./ingress-controller local wait

.PHONY: local
local:
	make -s -C ./operator-framework local wait
	make -s -C ./ingress-controller local wait
	make -s -C ./cert-manager local wait
	make -s -C ./jaeger-operator local wait
	make -s -C ./opentelemetry-operator local wait
	make -s -C ./apps local wait

.PHONY: local-monitoring
local-monitoring:
	make -s -C ./operator-framework local wait
	#make -s -C ./ingress-controller local wait
	make -s -C ./cert-manager local wait
	make -s -C ./jaeger-operator local wait test
	make -s -C ./opentelemetry-operator local wait test
	make -s -C ./kube-prometheus-stack local wait test
	make -s -C ./apps local wait test

.PHONY: local-monitoring-wait
local-monitoring-wait:
	make -s -C ./operator-framework wait
	make -s -C ./ingress-controller wait
	make -s -C ./cert-manager wait
	make -s -C ./jaeger-operator wait
	make -s -C ./opentelemetry-operator wait
	make -s -C ./kube-prometheus-stack wait
	make -s -C ./apps wait

.PHONY: local
local: ingress-controller mysql local-monitoring

.PHONY: ubuntu
ubuntu:
	kubectl run ubuntu --rm --tty -i --restart='Never' --image ubuntu --command -- bash

.PHONY: busybox
busybox:
	kubectl run busybox --rm --tty -i --restart='Never' --image busybox --command -- bash

.PHONY: test
test:
