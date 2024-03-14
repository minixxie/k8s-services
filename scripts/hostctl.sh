#!/bin/bash

if [ "$(which hostctl)" == "" ]; then
	echo "Missing hostctl command..."
	sudo snap install hostctl
fi
