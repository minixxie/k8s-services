#!/bin/bash

scriptPath=$(cd $(dirname "$0") && pwd)

set -e

if [ $UID -ne 0 ]; then
	echo >&2 "usage: sudo $0"
	exit 1
fi

if [ "$(which docker)" != "" ]; then
	ENGINE=docker
else
	ENGINE=containerd
fi

if [ "$ENGINE" == docker ]; then
	sudo apt install -q -y docker.io
	sudo usermod -aG docker $USER
	curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--docker" K3S_KUBECONFIG_MODE="644" sh -
else
	curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" sh -
fi
systemctl start k3s
systemctl enable k3s

set +e
grep 'export KUBECONFIG=' /etc/bash.bashrc
if [ $? -eq 0 ]; then
	echo "Replace export command..."
	sed -i 's#^export KUBECONFIG=.*$#export KUBECONFIG=/etc/rancher/k3s/k3s.yaml#' /etc/bash.bashrc
else
	echo "Add export command..."
	echo 'export KUBECONFIG=/etc/rancher/k3s/k3s.yaml' >> /etc/bash.bashrc
fi
#chmod 600 /etc/rancher/k3s/k3s.yaml

NS=default SERVICE_ACCOUNT=default "$scriptPath"/k8s-wait-serviceaccount.sh
NS=kube-system LABELS=svccontroller.k3s.cattle.io/svcname=traefik "$scriptPath"/k8s-wait-daemonset.sh
