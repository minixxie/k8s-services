#!/bin/bash

scriptPath=$(cd $(dirname "$0") && pwd)

set -e

if [ $UID -ne 0 ]; then
	echo >&2 "usage: sudo $0"
	exit 1
fi

curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" sh -
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
