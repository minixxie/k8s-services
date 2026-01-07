#!/bin/bash

scriptPath=$(cd $(dirname "$0") && pwd)

#"$scriptPath"/is-mainland-china.sh
#isMainlandChina=$?
isMainlandChina=1  # not yet fully implemented correctly

echo "IS mainland china? $isMainlandChina"

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
	if [[ $isMainlandChina -eq 0 ]]; then
		echo "installing k3s using CN mirrors..."
		#curl -sfL --insecure https://mirror.ghproxy.com/https://raw.githubusercontent.com/k3s-io/k3s/main/install.sh | INSTALL_K3S_MIRROR=cn INSTALL_K3S_EXEC="$nvidiaRuntime" K3S_KUBECONFIG_MODE="644" sh -
		#sudo wget --no-check-certificate https://rancher-mirror.oss-cn-beijing.aliyuncs.com/k3s/v1.33.6+k3s1/k3s-amd64 -O /usr/local/bin/k3s
		#sudo wget --no-check-certificate https://mirrors.cloud.tencent.com/k3s/v1.33.6+k3s1/k3s-amd64 -O /usr/local/bin/k3s
		#sudo wget http://mirror.ghproxy.com/https://github.com/k3s-io/k3s/releases/download/v1.33.6+k3s1/k3s-amd64 -O /usr/local/bin/k3s
		sudo curl -sfL https://rancher-mirror.rancher.cn/k3s/k3s-install.sh | INSTALL_K3S_MIRROR=cn INSTALL_K3S_EXEC="$nvidiaRuntime" K3S_KUBECONFIG_MODE="644" \
			INSTALL_K3S_REGISTRIES="https://registry.cn-hangzhou.aliyuncs.com,https://mirror.ccs.tencentyun.com" sh -s - \
			--system-default-registry=registry.cn-hangzhou.aliyuncs.com
	else
		curl -sfL https://get.k3s.io | INSTALL_K3S_EXEC="$nvidiaRuntime" K3S_KUBECONFIG_MODE="644" sh -
	fi

fi
systemctl start k3s
systemctl enable k3s

echo "Waiting for k3s API server to become available..."
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml || true; \
	timeout 120 bash -c 'until kubectl get --raw="/api/v1/namespaces/kube-system" >/dev/null 2>&1; do echo "Waiting for k3s API..."; sleep 5; done'
echo "Waiting for core components to be ready..."
# export KUBECONFIG=/etc/rancher/k3s/k3s.yaml || true; \
# 	kubectl wait --for=condition=Ready pods --all -n kube-system --timeout=180s || echo "Warning: Not all pods are ready, but continuing anyway"

NAMESPACE="kube-system"
TIMEOUT=300  # 5 minutes in seconds
INTERVAL=5   # Check every 5 seconds
ELAPSED=0

while [[ $ELAPSED -lt $TIMEOUT ]]; do
    # Get the number of pods that are not in the "Running" or "Succeeded" state
    NOT_READY_PODS=$(kubectl get pods -n $NAMESPACE --field-selector=status.phase!=Running,status.phase!=Succeeded --no-headers | wc -l)

    if [[ $NOT_READY_PODS -eq 0 ]]; then
        echo "All pods in the '$NAMESPACE' namespace are ready."
        break  # Exit the loop if all pods are ready
    fi

    echo "Waiting for all pods to be ready... ($NOT_READY_PODS not ready)"
    sleep $INTERVAL
    ELAPSED=$((ELAPSED + INTERVAL))
done

# Check if the timeout was reached
if [[ $ELAPSED -ge $TIMEOUT ]]; then
    echo "Timeout reached: Not all pods in the '$NAMESPACE' namespace are ready after 5 minutes."
    exit 1  # Exit with status 1 when the timeout occurs
fi

echo "k3s is ready!"

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
