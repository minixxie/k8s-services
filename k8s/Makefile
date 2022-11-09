.PHONY: check
check:
	kubectl config get-clusters
	kubectl config current-context
	kubectl get namespace

# minikube delete; minikube start --driver=virtualbox && minikube addons enable ingress
# minikube delete; minikube start --driver=hyperkit && minikube addons enable ingress
# minikube delete; minikube start --driver=virtualbox --host-only-cidr='172.16.0.1/20' && minikube addons enable ingress
.PHONY: recreate-cluster
recreate-cluster:
	minikube delete ; minikube start --driver=hyperkit
	minikube addons enable ingress
	minikube addons list
	make check
	@ip=$$(minikube ip); echo "Make sure to put entries into /etc/hosts:"; echo "$$ip grafana.minikube"

.PHONY: index
index:
	./bin/gen-index-html.sh

mysql:
	helm uninstall mysql || true
	helm repo add bitnami https://charts.bitnami.com/bitnami
	helm repo list
	helm install mysql bitnami/mysql -n db --create-namespace
	kubectl -n db get pod
	MYSQL_ROOT_PASSWORD=$$(kubectl get secret --namespace db mysql -o jsonpath="{.data.mysql-root-password}" | base64 -d) \
		&& echo MYSQL_ROOT_PASSWORD=$$MYSQL_ROOT_PASSWORD

mysql-cli:
	kubectl run mysql-client --rm --tty -i --restart='Never' --image  docker.io/bitnami/mysql:8.0.31-debian-11-r0 --namespace db --env MYSQL_ROOT_PASSWORD=$MYSQL_ROOT_PASSWORD --command -- bash

