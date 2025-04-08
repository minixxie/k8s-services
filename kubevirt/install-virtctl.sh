#!/bin/bash

# https://kubevirt.io/quickstart_cloud/

#kubectl get kubevirt.kubevirt.io/kubevirt -n kubevirt -oyaml

while true; do
    VERSION=$(kubectl get kubevirt.kubevirt.io/kubevirt -n kubevirt -o=jsonpath="{.status.observedKubeVirtVersion}")
    if [ -n "$VERSION" ]; then
        echo "KubeVirt Version: $VERSION"
        break
    else
        echo "Waiting for KubeVirt version to be available..."
        sleep 5
    fi
done
#VERSION=$(kubectl get kubevirt.kubevirt.io/kubevirt -n kubevirt -o=jsonpath="{.status.observedKubeVirtVersion}")
echo "VERSION: $VERSION"
ARCH=$(uname -s | tr A-Z a-z)-$(uname -m | sed 's/x86_64/amd64/') || windows-amd64.exe
echo ${ARCH}
echo curl -L -o virtctl https://github.com/kubevirt/kubevirt/releases/download/${VERSION}/virtctl-${VERSION}-${ARCH}
curl -L -o virtctl https://github.com/kubevirt/kubevirt/releases/download/${VERSION}/virtctl-${VERSION}-${ARCH}
chmod +x virtctl
sudo install virtctl /usr/local/bin
