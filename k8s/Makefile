.PHONY: check
check:
	kubectl config get-clusters
	kubectl config current-context
	kubectl get namespace

# minikube delete; minikube start --driver=virtualbox && minikube addons enable ingress
# minikube delete; minikube start --driver=hyperkit && minikube addons enable ingress
# minikube delete; minikube start --driver=hyperkit --cpus 4 --memory 8192 && minikube addons enable ingress
# minikube delete; minikube start --driver=virtualbox --host-only-cidr='172.16.0.1/20' && minikube addons enable ingress
.PHONY: recreate-cluster
recreate-cluster:
	#minikube delete ; minikube start --driver=hyperkit --cpus 4 --memory 8192
	#minikube delete ; minikube start --driver=hyperkit --cpus 2 --memory 4096
	minikube delete ; minikube start --driver=hyperkit --cpus 2 --memory 2048
	make ingress-controller
	make check
	make hosts

# Solution 1:
# minikube addons enable ingress
# minikube addons list
# Solution 2:
#	helm repo add nginx-stable https://helm.nginx.com/stable || true
#	helm repo update
#	helm upgrade --install nginx-ingress nginx-stable/nginx-ingress || true
.PHONY: ingress-controller
ingress-controller:
	minikube addons enable ingress
	minikube addons list

.PHONY: index
index:
	./bin/gen-index-html.sh

.PHONY: hosts
hosts:
	@ip=$$(minikube ip); \
	echo "## Copy and paste this section into your /etc/hosts file:"; \
	echo "$$ip  minikube"; \
	echo "$$ip  grafana.minikube"; \
	echo "$$ip  prometheus.minikube"; \
	echo "$$ip  mysql-exporter.minikube"; \
	echo "$$ip  mimir.minikube"; \
	echo "$$ip  kubeapps.minikube"; \
	echo "$$ip  echo-server-api.minikube";

.PHONY: mysql
mysql:
	cd mysql && make up \
		&& make mysql-exporter

.PHONY: mysql-exporter
mysql-exporter:
	cd prometheus-mysql-exporter && make up

.PHONY: kube-prometheus-stack
kube-prometheus-stack:
	cd kube-prometheus-stack && make up \
		&& make mysql-exporter
