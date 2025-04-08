#!/bin/bash

groups | grep kvm
if ! [ $? -eq 0 ]; then
	echo "not in kvm group, adding..."
	sudo usermod -aG kvm $(whoami)
	echo "Please logout and login again to be effective, otherwise the k8s won't be able to create VM."
fi
