#!/bin/bash

scriptPath=$(cd $(dirname "$0") && pwd)

if [ $UID -ne 0 ]; then
	echo >&2 "usage: sudo $0"
	exit 1
fi
set -e

cd /tmp/
curl -OL https://github.com/containerd/nerdctl/releases/download/v1.7.5/nerdctl-1.7.5-linux-amd64.tar.gz
#curl -OL https://github.com/containerd/nerdctl/releases/download/v2.0.0-beta.4/nerdctl-2.0.0-beta.4-linux-amd64.tar.gz
cd /usr/bin
tar xzvf /tmp/nerdctl-1.7.5-linux-amd64.tar.gz
#tar xzvf /tmp/nerdctl-2.0.0-beta.4-linux-amd64.tar.gz

chown root:root /usr/bin/nerdctl
chmod +s /usr/bin/nerdctl

set +e
grep 'export CONTAINERD_ADDRESS=' /etc/bash.bashrc
if [ $? -eq 0 ]; then
	echo "Replace export command..."
	sed -i 's#^export CONTAINERD_ADDRESS=.*$#export CONTAINERD_ADDRESS=/run/k3s/containerd/containerd.sock#' /etc/bash.bashrc
else
	echo "Add export command..."
	echo 'export CONTAINERD_ADDRESS=/run/k3s/containerd/containerd.sock' >> /etc/bash.bashrc
fi

if ! [ -f /etc/cni/net.d/nerdctl-bridge.conflist ]; then
	echo >&2 "ERR: /etc/cni/net.d/nerdctl-bridge.conflist doesn't exist, it may cause error!"
	echo >&2 "Suggest to: sudo cp \"$scriptPath\"/nerdctl-bridge.conflist /etc/cni/net.d/nerdctl-bridge.conflist"
fi
