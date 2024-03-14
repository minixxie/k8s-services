SHELL := /bin/bash

.PHONY: get local down logs test

get:
	kubectl -n apollo-server-go get all
	kubectl -n apollo-server-go get ing

local:
	kubectl apply -k .

down:
	kubectl delete -k .

logs:
	kubectl -n apollo-server-go logs -l app=apollo-server-go -f

test:
	curl -v http://apollo-server-go.local/services/config
