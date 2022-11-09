.PHONY: up
up:
	helm repo add ealenn https://ealenn.github.io/charts
	helm repo update
	helm upgrade --install echo-server-api ealenn/echo-server -n apps --create-namespace --set ingress.enable=true
	helm list -n apps
	kubectl apply -f ./echo-server-api.ingress.yaml
	kubectl get deployment echo-server-api -n apps
	kubectl get pod -n apps | grep echo-server-api
	@echo "Remember to add these to /etc/hosts:"
	@echo "$$(minikube ip)  echo-server-api.minikube"
	@echo "And you can try 'make test' to test the API endpoint. Ref: https://github.com/Ealenn/Echo-Server"

.PHONY: down
down:
	kubectl delete ing echo-server-api -n apps
	helm uninstall echo-server-api -n apps || true

.PHONY: test
test:
	if [ "$$(which python)" != "" ]; then \
		curl -v -H 'Host: echo-server-api.minikube' "http://$$(minikube ip)/param?query=demo" | python -m json.tool; \
	else \
		curl -v -H 'Host: echo-server-api.minikube' "http://$$(minikube ip)/param?query=demo"; \
	fi
