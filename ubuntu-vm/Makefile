SHELL := /bin/bash

.PHONY: get
get:
	kubectl -n ubuntu-vm get vms
	kubectl -n ubuntu-vm get vmis
	kubectl -n ubuntu-vm get all
	kubectl -n ubuntu-vm get pvc
	kubectl get pv

.PHONY: img
img:

.PHONY: up
up:
	kubectl apply -f vm.yaml
	kubectl -n ubuntu-vm get vms

.PHONY: local
local: up

.PHONY: down
down:
	kubectl delete -f vm.yaml || true

.PHONY: wait
wait:
	kubectl -n ubuntu-vm wait --for=condition=Ready vm/ubuntu-vm --timeout=120s

.PHONY: logs
logs:
	kubectl -n ubuntu-vm logs -f $$(kubectl -n ubuntu-vm get pod | sed 1d | awk '{print $$1}')

.PHONY: exec
exec:
	kubectl -n ubuntu-vm exec -it $$(kubectl -n ubuntu-vm get pod | sed 1d | awk '{print $$1}') -- bash

.PHONY: desc
desc:
	kubectl -n ubuntu-vm describe vms ubuntu-vm

.PHONY: vnc
vnc:
	virtctl -n ubuntu-vm vnc ubuntu-vm

.PHONY: console
console:
	virtctl -n ubuntu-vm console ubuntu-vm

.PHONY: ssh
ssh:
	ssh-keygen -f ~/.ssh/known_hosts -R "vmi/ubuntu-vm.ubuntu-vm" || true
	virtctl -n ubuntu-vm ssh ubuntu@ubuntu-vm

.PHONY: init
init:
	ssh-keygen -f ~/.ssh/known_hosts -R "vmi/ubuntu-vm.ubuntu-vm" || true
	# tightvncserver or tigervnc-standalone-server
	virtctl -n ubuntu-vm ssh ubuntu@ubuntu-vm -c "sudo apt-get update && sudo apt-get install -q -y net-tools tightvncserver xserver-xorg-input-all xfce4 xfce4-goodies"


.PHONY: restart
restart:
	virtctl -n ubuntu-vm restart ubuntu-vm

.PHONY: start
start:
	virtctl -n ubuntu-vm start ubuntu-vm

.PHONY: stop
stop:
	virtctl -n ubuntu-vm stop ubuntu-vm || true
