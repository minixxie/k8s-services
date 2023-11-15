SHELL := /bin/bash

.PHONY: check
check:
	kubectl get node
	kubectl config get-clusters
	kubectl config current-context
	kubectl get namespace
	kubectl get all -A

# minikube delete; minikube start --driver=virtualbox && minikube addons enable ingress
# minikube delete; minikube start --driver=hyperkit && minikube addons enable ingress
# minikube delete; minikube start --driver=hyperkit --cpus 4 --memory 8192 && minikube addons enable ingress
# minikube delete; minikube start --driver=virtualbox --host-only-cidr='172.16.0.1/20' && minikube addons enable ingress
# minikube delete; minikube start --driver=docker
#.PHONY: minikube
#minikube:
#	#minikube delete ; minikube start --driver=hyperkit --cpus 4 --memory 8192
#	#minikube delete ; minikube start --driver=hyperkit --cpus 2 --memory 4096
#	minikube delete ; minikube start --driver=hyperkit --cpus 2 --memory 2048
#	minikube addons enable ingress
#	minikube addons list
#	make check
#	./bin/gen-hosts.sh $$(minikube ip)

# Solution 1:
# minikube addons enable ingress
# minikube addons list
# Solution 2:
#	helm repo add nginx-stable https://helm.nginx.com/stable || true
#	helm repo update
#	helm upgrade --install nginx-ingress nginx-stable/nginx-ingress || true


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

.PHONY: colima
colima:
	colima start -k --runtime containerd \
		--cpu $$(expr $$(make -s ncpu) / 2) \
		--memory $$(expr $$(make -s mem) / 2)

.PHONY: index
index:
	./bin/gen-index-html.sh

.PHONY: kubeapps
kubeapps:
	make -C ./kubeapps up

.PHONY: mysql
mysql:
	make -C ./mysql up \
		&& make mysql-exporter

.PHONY: mysql-exporter
mysql-exporter:
	make -C ./prometheus-mysql-exporter up

.PHONY: kube-prometheus-stack
kube-prometheus-stack:
	make -C ./kube-prometheus-stack up \
		&& make mysql-exporter

.PHONY: kafka
kafka:
	make -C ./kafka up \
		&& make -C ./kafka-ui up
