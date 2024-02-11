#!/bin/bash

if [ $UID -ne 0 ]; then
	echo >&2 "usage: sudo $0"
	exit 1
fi
set -e

cd /tmp/
curl -OL https://github.com/containerd/nerdctl/releases/download/v1.7.3/nerdctl-1.7.3-linux-amd64.tar.gz
cd /usr/
tar xzvf /tmp/nerdctl-1.7.3-linux-amd64.tar.gz

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
