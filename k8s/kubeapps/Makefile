.PHONY: up
up:
	# https://kubeapps.dev/
	helm repo add bitnami https://charts.bitnami.com/bitnami || true
	helm repo update || true
	helm upgrade --install -n kubeapps --create-namespace kubeapps bitnami/kubeapps
	kubectl create --namespace default serviceaccount kubeapps-operator
	kubectl create clusterrolebinding kubeapps-operator --clusterrole=cluster-admin --serviceaccount=default:kubeapps-operator
	kubectl apply -f ./kubeapps.secret.yaml
	kubectl apply -f ./kubeapps.ingress.yaml
	pass=$(kubectl get --namespace default secret kubeapps-operator-token -o go-template='{{.data.token | base64decode}}' ; echo) ; echo "pass: $pass"

.PHONY: down
down:
	kubectl delete ing kubeapps -n kubeapps || true
	kubectl delete secret kubeapps-operator-token -n default || true
	kubectl delete clusterrolebinding kubeapps-operator || true
	kubectl delete serviceaccount kubeapps-operator -n default || true
