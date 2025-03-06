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

nvidia=0
if lspci | grep -i nvidia; then
	nvidia=1
fi
if [ "$(which nvidia-smi)" != "" ]; then
	nvidia-smi > /dev/null
	if [ $? -eq 0 ]; then
		nvidia=1
	fi
fi

nvidiaRuntime=""
if [ $nvidia -eq 1 ]; then
	nvidiaRuntime="--default-runtime=nvidia"
fi

if [ "$ENGINE" == docker ]; then
	sudo apt install -q -y docker.io
	sudo usermod -aG docker $USER
	curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="--docker $nvidiaRuntime" K3S_KUBECONFIG_MODE="644" sh -
else
	curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="$nvidiaRuntime" K3S_KUBECONFIG_MODE="644" sh -
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

# assuming you have installed "nvidia-container-runtime" already with the below,
# tell the nvidia-container-runtime where is the k3s containerd:
#        # https://nvidia.github.io/nvidia-container-runtime/
#        curl -s -L https://nvidia.github.io/nvidia-container-runtime/gpgkey | \
#                sudo apt-key add -
#        distribution=$$(. /etc/os-release;echo $$ID$$VERSION_ID); \
#                curl -s -L https://nvidia.github.io/nvidia-container-runtime/$$distribution/nvidia-container-runtime.list | \
#                sudo tee /etc/apt/sources.list.d/nvidia-container-runtime.list
#        sudo apt update
#        sudo apt install -q -y nvidia-container-runtime
#
if [ $nvidia -eq 1 ]; then
	if ! grep -q "socket-path" /etc/nvidia-container-runtime/config.toml; then
	    echo "[nvidia-container-runtime]" >> /etc/nvidia-container-runtime/config.toml
	    echo "  socket-path = \"/run/k3s/containerd/containerd.sock\"" >> /etc/nvidia-container-runtime/config.toml
	    echo "socket-path added to /etc/nvidia-container-runtime/config.toml"
	else
	    echo "socket-path already exists in /etc/nvidia-container-runtime/config.toml"
	fi
fi

NS=default SERVICE_ACCOUNT=default "$scriptPath"/k8s-wait-serviceaccount.sh
NS=kube-system LABELS=svccontroller.k3s.cattle.io/svcname=traefik "$scriptPath"/k8s-wait-daemonset.sh
