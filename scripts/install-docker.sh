#!/bin/bash

set -e
sys=$(uname -s)
if [ "$sys" == "Darwin" ]; then
	echo >&2 "ERR: not implemented"
else
	sudo apt install -q -y docker.io
	sudo usermod -aG docker $USER
	sudo systemctl restart docker
fi
