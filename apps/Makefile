SHELL := /bin/bash

.PHONY: up
up:
	kubectl apply -k .

.PHONY: local
local: up

.PHONY: down
down:
	kubectl delete -k .

.PHONY: wait
wait:
	# NOOP

.PHONY: test
test:
	# NOOP
