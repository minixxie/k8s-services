#!/bin/bash

if [ $UID -ne 0 ]; then
	echo >&2 "usage: sudo $0"
	exit 1
fi

curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" sh -
systemctl start k3s
systemctl enable k3s
systemctl status k3s
